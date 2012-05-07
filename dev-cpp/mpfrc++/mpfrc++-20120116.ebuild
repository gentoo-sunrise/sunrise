# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs vcs-snapshot

DESCRIPTION="High-performance C++ interface for MPFR library"
HOMEPAGE="http://www.holoborodko.com/pavel/mpfr/"
SRC_URI="http://github.com/downloads/jauhien/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/mpfr"
RDEPEND="${DEPEND}"

src_prepare() {
	cp "${FILESDIR}/Makefile" Makefile || die
}

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	dolib.so lib${PN}.so.${PV}
	dosym lib${PN}.so.${PV} usr/$(get_libdir)/lib${PN}.so
	insinto usr/include
	doins dlmalloc.h mpreal.h
}
