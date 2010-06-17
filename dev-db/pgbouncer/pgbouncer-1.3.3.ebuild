# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

RESTRICT="test"

DESCRIPTION="Lightweight connection pooler for PostgreSQL"
HOMEPAGE="http://pgfoundry.org/projects/pgbouncer/"
SRC_URI="http://pgfoundry.org/frs/download.php/2677/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND=">=virtual/postgresql-base-8.0
	dev-libs/libevent"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup pgbouncer
	enewuser pgbouncer -1 -1 -1 pgbouncer
}

src_prepare() {
	epatch "${FILESDIR}/modify-config-paths.patch"
	eautoreconf -f
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable debug cassert) \
		--docdir=/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	insinto /etc
	newins etc/pgbouncer.ini pgbouncer.conf || die "Install failed"
	newinitd "${FILESDIR}"/pgbouncer.initd "${PN}" || die "Install failed"

	dodoc README NEWS AUTHORS || die "Install failed"
	if use doc ; then
		dodoc doc/*.txt || die "Install failed"
	fi

	dodir /var/{run,log}/pgbouncer/
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
