# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

KEYWORDS="~x86"

DESCRIPTION="SQL C++ code generator (to use with dev-db/*wrapped packages)"
HOMEPAGE="http://www.alhem.net/project/sql2class/index.html"
SRC_URI="http://www.alhem.net/project/sql2class/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="mysql sqlite"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's/\(CPPFLAGS\) =/\1+=/' \
		-e 's/-Wall -O2 -g//' \
		-e 's#/usr/devel#/usr#' \
		-e 's/g++/$(CXX)/' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CXX="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dobin sql2class
	dodoc README
}

pkg_postinst() {
	elog "You might want to emerge one of the following packages as well:"
	elog "-> dev-db/mysqlwrapped ... to use the generated code with a MySQL-DB"
	elog "-> dev-db/sqlitewrapped ... to use the generated code with SQLite"
}
