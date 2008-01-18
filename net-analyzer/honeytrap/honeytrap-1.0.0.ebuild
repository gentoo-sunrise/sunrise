# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools linux-info

DESCRIPTION="Network security tool for observing network services via low-interactive honeypot"
HOMEPAGE="http://honeytrap.mwcollect.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcap-mon ipq-mon nfq-mon clamav postgres spamsum cspm efence debug profile"

RDEPEND="pcap-mon? ( virtual/libpcap )
	ipq-mon? ( net-firewall/iptables )
	nfq-mon? ( net-firewall/iptables net-libs/libnetfilter_queue )
	!pcap-mon? ( !nfq-mon? ( !ipq-mon? ( net-firewall/iptables ) ) )
	clamav? ( app-antivirus/clamav )
	postgres? ( dev-db/postgresql )
	cspm? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	efence? ( dev-util/efence )"

pkg_setup() {
	enewgroup honeytrap
	enewuser honeytrap -1 -1 -1 honeytrap

	if ! use pcap-mon && ! use ipq-mon && ! use nfq-mon ; then
		ewarn "You did not choose any connection monitor."
		ewarn "Currently pcap-based, ip_queue-based and nf_queue-based monitors are supported."
		ewarn "Defaulting to ip_queue; if this is not what you want, you should add either"
		ewarn "pcap-mon or nfq-mon to your USE flags and re-emerge this ebuild."
		epause 3
	fi

	if use efence ; then
		ewarn "You have enabled a link with Electric Fence malloc debugger."
		ewarn "It is known that honeytrap will not work with efence and xen-sources."
		epause 3
	fi

	if use cspm ; then
		ewarn "You have enabled CSPM, shellcode pattern matching plugin."
		ewarn "The CSPM plugin is still unstable and should not be used in production setups."
		epause 3
	fi

	use ipq-mon && CONFIG_CHECK="IP_NF_QUEUE"
	use nfq-mon && CONFIG_CHECK="NETFILTER_NETLINK_QUEUE"
	linux-info_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Automake files are a mess; a review of these is in the upstream todo-list.
	# This patch could be nicer, but at least it prevents ugly things from happening with use_enable.
	epatch "${FILESDIR}/${PN}-1.0.0-autoconf.patch"

	einfo "Regenerating autoconf/automake files."
	eautoreconf
}

src_compile() {
	local myconf

	if use pcap-mon ; then
		myconf="${myconf} --with-stream-mon=pcap"
	elif use ipq-mon ; then
		myconf="${myconf} --with-stream-mon=ipq --with-libipq-includes=/usr/include/libipq"
	elif use nfq-mon ; then
		myconf="${myconf} --with-stream-mon=nfq --with-libnfq-includes=/usr/include/libnetfilter_queue"
	elif ! use pcap-mon && ! use ipq-mon && ! use nfq-mon ; then
		myconf="${myconf} --with-stream-mon=ipq --with-libipq-includes=/usr/include/libipq"
	fi

	# Note: enabling --devmodules replaces also CFLAGS; keep it this way.
	if use cspm ; then
		myconf="${myconf} --enable-devmodules"
	fi

	econf \
		$(use_with clamav) \
		$(use_with postgres) \
		$(use_with spamsum) \
		$(use_with cspm) \
		$(use_with efence) \
		$(use_enable debug) \
		$(use_enable profile) \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Unfortunately the dynamic shared plugins are installed into /etc/honeytrap/plugins by default.
	# The easiest way is to just move them and put them into /usr/src/honeytrap_dynamicsrc (cf. Snort).
	dodir /usr/src
	mv "${D}"/etc/honeytrap/plugins "${D}"/usr/src/honeytrap_dynamicsrc || die

	# As the ebuild includes a modified version of this file, no need to copy this into the live system.
	rm -f "${D}"/etc/honeytrap/honeytrap.conf*

	mv "${D}"/etc/honeytrap/ports.conf.dist "${D}"/etc/honeytrap/ports.conf

	# Note: NEWS is empty, so no need for it; man-file is installed without doman.
	dodoc README TODO ChangeLog

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	cp "${FILESDIR}"/honeytrap.conf "${D}"/etc/honeytrap/honeytrap.conf

	keepdir /var/log/honeytrap
	keepdir /var/log/honeytrap/attacks
	keepdir /var/log/honeytrap/downloads

	fowners -R honeytrap:honeytrap /var/log/honeytrap
	fperms 0700 -R /var/log/honeytrap
}

pkg_postinst() {
	ewarn
	ewarn "WARNING (from the README):"
	ewarn "Honeytrap is a low-interactive honeypot and therefore detectable."
	ewarn "It  is  written  in  C  and thus potentially vulnerable to buffer"
	ewarn "overflow attacks. Take care. Running in mirror mode is dangerous."
	ewarn "Attacks  may  be directed to the attacker, appearing to come from"
	ewarn "your system. Use with caution."
	ewarn
}
