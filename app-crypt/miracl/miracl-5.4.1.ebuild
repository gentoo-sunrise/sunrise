# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib toolchain-funcs

DESCRIPTION="Big number cryptography library"
HOMEPAGE="http://www.shamus.ie"
SRC_URI="http://chaox.net/~jens/${P}.tar.bz2"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-fix-buildsystem.patch
	epatch "${FILESDIR}"/${PN}-noexecstack.patch
}

src_compile() {
	chmod +x ./linux || die
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" AS="$(tc-getAS)" AR="$(tc-getAR)" ./linux || die
}

src_install() {
	dolib.a lib${PN}.a || die
	dolib.so lib${PN}.so.0.0.0 || die
	dosym lib${PN}.so.0.0.0 /usr/$(get_libdir)/lib${PN}.so || die
	insinto /usr/include/${PN}
	doins ${PN}.h mirdef.h || die
	dodoc *.txt || die
}
