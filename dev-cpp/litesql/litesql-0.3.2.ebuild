# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit autotools eutils

KEYWORDS="~x86"

DESCRIPTION="C++ library that integrates C++ objects tightly to relational database and thus provides an object persistence layer."
HOMEPAGE="http://litesql.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE="doc examples mysql postgres sqlite"

DEPEND="doc? ( app-doc/doxygen )
		mysql? ( virtual/mysql )
		postgres? ( dev-db/libpq )
		sqlite? ( =dev-db/sqlite-3* )
		!mysql? ( !postgres? ( =dev-db/sqlite-3* ) )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! ( use mysql || use postgres || use sqlite ) ; then
		ewarn "You have to specify at least one of the following  USE-flags:"
		ewarn "'mysql postgresq sqlite'"
		ewarn "None specified: support for sqlite automatically activated."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-extra_qualifier.patch"
	epatch "${FILESDIR}/${P}-pkg_makefile_am.patch"

	sed -i \
		-e 's/docs//' \
		-e 's/examples//' \
		src/Makefile.am || die "sed failed"

	eautoreconf
}

src_compile() {
	econf \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with sqlite sqlite3) \
		|| die "econf failed"
	emake || die "emake failed"

	if use examples ; then
		cd "${S}/src/examples"
		emake || die "emake failed"
	fi
	if use doc ; then
		cd "${S}/docs/doxygen"
		doxygen doxygen.conf
	fi

}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use examples ; then
		rm "${S}/src/examples"/Makefile* "${S}/src/examples"/*.o
		insinto /usr/share/${PN}
		doins -r src/examples
	fi

	if use doc ; then
		dohtml docs/html/*
	fi
}
