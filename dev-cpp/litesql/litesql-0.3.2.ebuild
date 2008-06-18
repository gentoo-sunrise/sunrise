# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Integrates C++ objects tightly to relational database and thus provides an object persistence layer."
HOMEPAGE="http://litesql.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples mysql postgres sqlite"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	sqlite? ( =dev-db/sqlite-3* )
	!mysql? ( !postgres? ( !sqlite? ( =dev-db/sqlite-3* ) ) )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if ! use mysql && ! use postgres && ! use sqlite ; then
		ewarn "You have to specify at least one of the mysql postgresq sqlite USE flags."
		ewarn "None specified: support for sqlite automatically activated."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch \
		"${FILESDIR}/${P}-extra_qualifier.patch" \
		"${FILESDIR}/${P}-pkg_makefile_am.patch" \
		"${FILESDIR}/${P}-gcc43_glibc28.patch"

	sed -i \
		-e 's/docs//' \
		-e 's/examples//' \
		Makefile.am || die "sed failed"

	eautoreconf
}

src_compile() {
	if ! use mysql && ! use postgres && ! use sqlite ; then
		local myconf="--with-sqlite3"
	fi
	econf \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with sqlite sqlite3) \
		${myconf}

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
		rm src/examples/Makefile* src/examples/*.o
		insinto /usr/share/${PF}
		doins -r src/examples
	fi

	if use doc ; then
		dohtml docs/html/*
	fi
}
