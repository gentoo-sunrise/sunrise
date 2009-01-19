# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="An authoritative only, high performance, open source name server"
HOMEPAGE="http://www.nlnetlabs.nl/projects/nsd"
SRC_URI="http://www.nlnetlabs.nl/downloads/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bind8-stats dnssec ipv6 largefile nsec3 nsid root-server runtime-checks tsig"

DEPEND="tsig? ( dev-libs/openssl )"
RDEPEND}${DEPEND}

pkg_setup() {
	if use runtime-checks; then
		ewarn "You enabled runtime-checks USE flag, this could lead to a reduced service level"
	fi
	if use nsid; then
		ewarn "You enabled nsid USE flag, this is still experimental"
	fi

	enewgroup nsd
	enewuser nsd -1 -1 -1 nsd
}

src_compile() {
	econf \
		--with-dbfile=/var/db/nsd/nsd.db \
		--with-difffile=/var/db/nsd/ixfr.db \
		--with-pidfile=/var/run/nsd.pid \
		--with-xfrdfile=/var/db/nsd/xfrd.state \
		--with-zonesdir=/var/lib/nsd \
		$(use_enable bind8-stats) \
		$(use_enable dnssec) \
		$(use_enable largefile) \
		$(use_enable ipv6) \
		$(use_enable nsec3) \
		$(use_enable nsid) \
		$(use_enable root-server) \
		$(use_enable runtime-checks checking) \
		$(use_enable tsig)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc doc/{ChangeLog,CREDITS,NSD-FOR-BIND-USERS,README,REQUIREMENTS} || die "dodoc failed"

	insinto /usr/share/${PN}
	doins "${FILESDIR}/nsd.cron" || die "doins failed"
	doins contrib/nsd.zones2nsd.conf || die "doins failed"

	newinitd "${FILESDIR}"/nsd.initd nsd || die "newinitd failed"
	newconfd "${FILESDIR}"/nsd.confd nsd || die "newconfd failed"

	# database directory, writable by nsd for ixfr.db file
	keepdir /var/db/nsd
	fowners nsd:nsd /var/db/nsd
	fperms 750 /var/db/nsd

	# zones directory, writable by root for 'nsdc patch'
	keepdir /var/lib/nsd
	fowners root:nsd /var/lib/nsd
	fperms 750 /var/lib/nsd
}

pkg_postinst() {
	elog "If you are using bind and want to convert (or sync) bind zones"
	elog "you should check out bind2nsd (http://bind2nsd.sourceforge.net)."
	echo
	elog "To automatically merge zone transfer changes back to NSD's"
	elog "zone files using 'nsdc patch', try nsd.cron in /usr/share/${PN}"
}
