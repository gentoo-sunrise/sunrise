# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="An authoritative only, high performance, open source name server"
HOMEPAGE="http://www.nlnetlabs.nl/projects/nsd"
SRC_URI="http://www.nlnetlabs.nl/downloads/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bind8-stats ipv6 nsec3 root-server runtime-checks"

DEPEND="dev-libs/openssl"
RDEPEND=${DEPEND}

pkg_setup() {
	if use runtime-checks; then
		ewarn "You enabled runtime-checks USE flag, this could lead to a reduced service level"
	fi
	enewgroup nsd
	enewuser nsd -1 -1 -1 nsd
}

src_prepare() {
	epatch "${FILESDIR}/${P}-configure.patch"
	eautoreconf
}

src_configure() {
	# ebuild.sh sets localstatedir to /var/lib, but nsd expects /var in several locations
	# some of these cannot be changed by arguments to econf/configure, f.i. logfile
	econf \
		--localstatedir=/var \
		--with-pidfile=/var/run/nsd/nsd.pid \
		--with-zonesdir=/var/lib/nsd \
		--enable-largefile \
		$(use_enable bind8-stats) \
		$(use_enable ipv6) \
		$(use_enable nsec3) \
		$(use_enable root-server) \
		$(use_enable runtime-checks checking)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc doc/{ChangeLog,CREDITS,NSD-FOR-BIND-USERS,README,REQUIREMENTS} \
		|| die "dodoc failed"

	insinto /usr/share/nsd
	doins contrib/nsd.zones2nsd.conf || die "doins failed"

	exeinto /etc/cron.daily
	doexe "${FILESDIR}/nsd.cron" || die "doexe failed"

	newinitd "${FILESDIR}"/nsd.initd nsd || die "newinitd failed"
	newconfd "${FILESDIR}"/nsd.confd nsd || die "newconfd failed"

	# database directory, writable by nsd for ixfr.db file
	dodir /var/db/nsd
	fowners nsd:nsd /var/db/nsd
	fperms 750 /var/db/nsd

	# zones directory, writable by root for 'nsdc patch'
	dodir /var/lib/nsd
	fowners root:nsd /var/lib/nsd
	fperms 750 /var/lib/nsd

	# pid dir, writable by nsd
	dodir /var/run/nsd
	fowners nsd:nsd /var/run/nsd
}

pkg_postinst() {
	elog "If you are using bind and want to convert (or sync) bind zones"
	elog "you should check out bind2nsd (http://bind2nsd.sourceforge.net)."
}
