# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit libtool flag-o-matic eutils autotools libtool

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A commercial-quality network protocol analyzer"
HOMEPAGE="http://www.wireshark.org/"
SRC_URI="http://www.wireshark.org/download/prerelease/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="adns gtk ipv6 snmp ssl kerberos threads"

RDEPEND=">=sys-libs/zlib-1.1.4
	!net-analyzer/ethereal
	snmp? ( >=net-analyzer/net-snmp-5.1.1 )
	gtk? ( >=dev-libs/glib-2.0.4
		=x11-libs/gtk+-2*
		x11-libs/pango
		dev-libs/atk )
	!gtk? ( =dev-libs/glib-1.2* )
	ssl? ( >=dev-libs/openssl-0.9.6e )
	!ssl? (	net-libs/gnutls )
	net-libs/libpcap
	>=dev-libs/libpcre-4.2
	adns? ( net-libs/adns )
	kerberos? ( virtual/krb5 )"
# lua fails with version 5.0 and 5.1 is not in portage yet - 2006-04-25	
#	lua? ( >=dev-lang/lua-5.1 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15.0
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	sys-apps/sed"

pkg_setup() {
	# bug 119208
	if built_with_use dev-lang/perl minimal ; then
		ewarn "wireshark will not build if dev-lang/perl is compiled with"
		ewarn "USE=minimal. Rebuild dev-lang/perl with USE=-minimal and try again."
		ebeep 5
		die "dev-lang/perl compiled with USE=minimal"
	fi
}

src_unpack() {
	unpack ${A}
	# bug 117716
	epatch "${FILESDIR}/${P}-as-needed.patch"
	cd "${S}"
	AT_M4DIR="${S}/aclocal-fallback" eautomake
	elibtoolize
}

src_compile() {
	replace-flags -O? -O

	# Fix gcc-3.4 segfault #49238
	#[ "`gcc-version`" == "3.4" ] && append-flags -fno-unroll-loops

	local myconf

	if use gtk; then
		einfo "Building with gtk support"
	else
		einfo "Building without gtk support"
		myconf="${myconf} --disable-wireshark"
		# the asn1 plugin needs gtk
		sed -i -e '/plugins.asn1/d' Makefile.in || die "sed failed"
		sed -i -e '/^SUBDIRS/s/asn1//' plugins/Makefile.in || die "sed failed"
	fi

	#	$(use_with lua) \
	econf \
		$(use_with ssl) \
		$(use_enable ipv6) \
		$(use_with adns) \
		$(use_with kerberos krb5) \
		$(use_with snmp net-snmp) \
		$(use_enable gtk gtk2) \
		$(use_enable threads) \
		--without-ucd-snmp \
		--enable-dftest \
		--enable-randpkt \
		--sysconfdir=/etc/wireshark \
		--enable-editcap \
		--enable-capinfos \
		--enable-text2pcap \
		--enable-dftest \
		--enable-randpkt \
		${myconf} || die "econf failed"

	# fixes an access violation caused by libnetsnmp - see bug 79068
	use snmp && export MIBDIRS="${D}/usr/share/snmp/mibs"

	emake || die "emake failed"
}

src_install() {
	dodir /usr/lib/wireshark/plugins/${PV}
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README*

	insinto /usr/share/icons/hicolor/16x16/apps
	newins "${S}"/image/hi16-app-wireshark.png wireshark.png
	insinto /usr/share/icons/hicolor/32x32/apps
	newins "${S}"/image/hi32-app-wireshark.png wireshark.png
	insinto /usr/share/icons/hicolor/48x48/apps
	newins "${S}"/image/hi48-app-wireshark.png wireshark.png
	make_desktop_entry wireshark "Wireshark" wireshark
}

pkg_postinst() {
	ewarn "Due to a history of security flaws in this piece of software, it may contain more flaws."
	ewarn "To protect yourself against malicious damage due to potential flaws in this product we recommend"
	ewarn "you take the following security precautions when running wireshark in an untrusted environment:"
	ewarn "do not run any longer than you need to;"
	ewarn "use in a root jail - prefereably one that has been hardened with grsec like rootjail protections;"
	ewarn "use a hardened operating system;"
	ewarn "do not listen to addition interfaces;"
	ewarn "if possible, run behind a firewall;"
	ewarn "take a capture with tcpdump and analyze running wireshark as a least privileged user;"
	ewarn "and subscribe to wireshark's announce list to be notified of newly discovered vulnerabilities."
}
