# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit user versionator

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

src_configure() {
	# ebuild.sh sets localstatedir to /var/lib, but nsd expects /var in several locations
	# some of these cannot be changed by arguments to econf/configure, f.i. logfile
	econf \
		--localstatedir="${EPREFIX}/var" \
		--with-pidfile="${EPREFIX}/var/run/nsd/nsd.pid" \
		--with-zonesdir="${EPREFIX}/var/lib/nsd" \
		--enable-largefile \
		$(use_enable bind8-stats) \
		$(use_enable ipv6) \
		$(use_enable nsec3) \
		$(use_enable root-server) \
		$(use_enable runtime-checks checking)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc doc/{ChangeLog,CREDITS,NSD-FOR-BIND-USERS,README,RELNOTES,REQUIREMENTS}

	insinto /usr/share/nsd
	doins contrib/nsd.zones2nsd.conf

	exeinto /etc/cron.daily
	doexe "${FILESDIR}/nsd.cron"

	newinitd "${FILESDIR}"/nsd.initd nsd
	newconfd "${FILESDIR}"/nsd.confd nsd

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
	version_compare "3.2.9" "${REPLACING_VERSIONS}"
	if test $? -eq 3; then
		ewarn "In ${PN}-3.2.9, the database format was changed."
		ewarn "Please run '/etc/init.d/nsd rebuild' to rebuild the database, then restart nsd."
	fi
}
