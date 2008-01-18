# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

KEYWORDS="~x86"

DESCRIPTION="Another C++ wrapper for the SQLite C API"
HOMEPAGE="http://www.alhem.net/project/sqlite/index.html"
SRC_URI="http://www.alhem.net/project/sqlite/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=dev-db/sqlite-3"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's/\(CPPFLAGS\) =/\1+=/' \
		-e 's/-Wall -g -O2/-fPIC/' \
		-e 's#/usr/devel#/usr#' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CXX="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dolib libsqlitewrapped.a
	insinto /usr/include
	doins libsqlitewrapped.h
}
