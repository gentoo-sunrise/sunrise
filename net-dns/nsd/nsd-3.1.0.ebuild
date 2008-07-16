# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="An authoritative only, high performance, open source name server"
HOMEPAGE="http://www.nlnetlabs.nl/projects/nsd"
SRC_URI="http://www.nlnetlabs.nl/downloads/nsd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bind8-stats dnssec ipv6 largefile nsec3 nsid root-server runtime-checks tsig"

DEPEND="tsig? ( >=dev-libs/openssl-0.9.8f )"

pkg_setup() {
	if use runtime-checks; then
		ewarn "You enabled runtime-checks USE flag, this could lead to a reduced service level"
	fi
	if use nsid; then
		ewarn "You enabled nsid USE flag, this is still experimental"
	fi

	enewuser nsd -1 -1 /var/lib/nsd
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
		$(use_enable tsig) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc doc/*
	dodoc contrib/nsd.zones2nsd.conf
	dodoc "${FILESDIR}"/nsd.cron

	dobin nsdc.sh

	newinitd "${FILESDIR}"/nsd.initd nsd

	keepdir /var/db/nsd
	fowners nsd /var/db/nsd
	fperms 750 /var/db/nsd

	keepdir /var/lib/nsd
	fowners nsd /var/lib/nsd
	fperms 750 /var/lib/nsd
}

pkg_postinst() {
	elog "If you are using bind and want to convert (or sync) bind zones"
	elog "you should check out bind2nsd (http://bind2nsd.sourceforge.net)."
	echo
	elog "If you are upgrading from NSD 2, take a look at the provided"
	elog "nsd.zones2nsd.conf script in the doc directory."
	echo
	elog "To automatically merge zone transfer changes back to NSD's"
	elog "zone files using 'nsdc patch', try the nsd.cron in the doc directory"
}
