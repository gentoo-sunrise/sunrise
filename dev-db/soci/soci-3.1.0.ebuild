# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

KEYWORDS="~x86"

DESCRIPTION="A db access library for C++ that makes the illusion of embedding SQL queries in the regular C++ code"
HOMEPAGE="http://soci.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
LICENSE="Boost-1.0"
SLOT="0"
IUSE="boost doc +empty mysql odbc oracle postgres sqlite"

DEPEND="boost? ( dev-libs/boost )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql-base )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND=${DEPEND}

src_configure() {
	local mycmakeargs="$(cmake-utils_use_with boost )
		$(cmake-utils_use empty SOCI_EMPTY)
		$(cmake-utils_use_with mysql MYSQL)
		$(cmake-utils_use_with odbc ODBC)
		$(cmake-utils_use_with oracle ORACLE)
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with sqlite SQLITE3)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS CHANGES
	if use doc; then
		dohtml -r doc/*
	fi
}
