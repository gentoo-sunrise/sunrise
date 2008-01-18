# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="an authoritative only, high performance, open source name server"
HOMEPAGE="http://www.nlnetlabs.nl/nsd/"
SRC_URI="http://www.nlnetlabs.nl/downloads/nsd/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="axfr bind8-stats checking dnssec ipv6 nsec3 nsid plugins root-server ssl tcpd tsig"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.7i )
	tcpd? ( sys-apps/tcp-wrappers )"

pkg_setup() {
	enewuser nsd -1 -1 /var/lib/nsd
}

src_compile() {
	if use plugins; then
		ewarn
		ewarn "Plugin support is highly experimental!"
		ewarn "Plugin support enabled!"
		epause 10
	fi

	econf \
		--with-user=nsd \
		--with-dbfile=/var/lib/nsd/nsd.db \
		--with-pidfile=/var/run/nsd/nsd.pid \
		--with-zonesdir=/var/lib/nsd \
		--with-difffile=/var/run/nsd/ \
		--with-xfrdfile==/var/run/nsd/ \
		$(use_enable axfr) \
		$(use_enable bind8-stats) \
		$(use_enable checking) \
		$(use_enable dnssec) \
		$(use_enable ipv6) \
		$(use_enable nsec3) \
		$(use_enable nsid) \
		$(use_enable plugins) \
		$(use_enable root-server) \
		$(use_with ssl) \
		$(use_enable tsig) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc doc/*
	dodoc contrib/nsd.zones2nsd.conf

	dobin nsdc.sh

	exeinto /etc/cron.hourly
	newexe "${FILESDIR}"/nsd.cron nsd.cron

	newinitd "${FILESDIR}"/nsd.initd nsd

	keepdir /var/run/nsd
	fowners nsd /var/run/nsd
	fperms 750 /var/run/nsd

	keepdir /var/lib/nsd
	fowners nsd /var/lib/nsd
	fperms 750 /var/lib/nsd
}
