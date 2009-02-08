# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Another C++ wrapper for the MySQL C API"
HOMEPAGE="http://www.alhem.net/project/mysql/index.html"
SRC_URI="http://www.alhem.net/project/mysql/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/mysql
		sys-libs/zlib"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/gcc-4.3.patch" \
		"${FILESDIR}/Makefile.patch"
}

src_compile() {
	emake CXX="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dolib libmysqlwrapped.a || die "dolib failed"
	insinto /usr/include
	doins libmysqlwrapped.h || die "doins failed"

	dodoc Changelog README || die "dodoc failed"
}
