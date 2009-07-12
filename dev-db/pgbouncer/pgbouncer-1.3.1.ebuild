# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Lightweight connection pooler for PostgreSQL"
HOMEPAGE="http://pgfoundry.org/projects/pgbouncer/"
SRC_URI="http://pgfoundry.org/frs/download.php/2284/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=virtual/postgresql-base-8.0
	>=dev-libs/libevent-1.3"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup pgbouncer
	enewuser pgbouncer -1 -1 -1 pgbouncer
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf -f
}

src_compile() {
	epatch "${FILESDIR}/modify-config-paths.patch"

	econf \
		$(use_enable debug) \
		$(use_enable debug cassert)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	insinto /etc
	newins "${S}"/etc/pgbouncer.ini pgbouncer.conf || die "Install failed"
	newinitd "${FILESDIR}"/pgbouncer.initd "${PN}" || die "Install failed"

	dodoc README NEWS AUTHORS || die "Install failed"
	dodoc doc/*.txt || die "Install failed"

	# Create log/run directories and set owner to pgbouncer
	keepdir /var/{run,log}/pgbouncer/
	fperms 0700 /var/{run,log}/pgbouncer/
	fowners pgbouncer:pgbouncer /var/{run,log}/pgbouncer/
}

pkg_postinst() {
	einfo "Please read the config.txt for Configuration Directives"
	einfo
	einfo "See 'man pgbouncer' for Administration Commands"
	einfo
	einfo "By default, PgBouncer does not have access to any databases."
	einfo "Create on with permissions needed for your application and"
	einfo "make sure that it exists in pgbouncer's auth_file."
}
