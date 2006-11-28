# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

KEYWORDS="~x86"

DESCRIPTION="A database access library for C++ that makes the illusion of embedding SQL queries in the regular C++ code."
HOMEPAGE="http://soci.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="Boost-1.0"
SLOT="0"
IUSE="mysql postgres sqlite3 static"

DEPEND="mysql? ( dev-db/mysql )
		postgres? ( dev-db/libpq )
		sqlit3? ( =dev-db/sqlite-3* )"
RDEPEND=""

src_compile() {
	local backends
	backends="core backends/empty"
	use mysql && backends="${backends} backends/mysql"
	use postgres && backends="${backends} backends/postgresql"
	use sqlite3 && backends="${backends} backends/sqlite3"

	for backend in ${backends} ; do
		cd "${S}/${backend}"
		emake \
			COMPILER=$(tc-getCXX) \
			CXXFLAGS="${CXXFLAGS}" \
			shared || die "emake ${backend} failed"
		if use static ; then
			emake \
				COMPILER=$(tc-getCXX) \
				CXXFLAGS="${CXXFLAGS}" \
				|| die "emake ${backend} failed"
		fi
	done
}


src_install() {
	dohtml doc/*
	dodoc CHANGES contrib README

	find . -iname "libsoci-*" | xargs dolib

	insinto /usr/include
	doins core/*.h backends/soci-{common,empty}.h
	use mysql && doins backends/soci-mysql.h
	use postgres && doins backends/soci-postgresql.h
	use sqlite3 && doins backends/soci-sqlite3.h
}
