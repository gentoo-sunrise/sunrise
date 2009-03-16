# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="TaskSpooler is a comfortable way of running batch jobs"
HOMEPAGE="http://vicerveza.homeunix.net/~viric/soft/ts/"
SRC_URI="http://vicerveza.homeunix.net/~viric/soft/ts/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's|CFLAGS=|CFLAGS+=|' \
		-e 's|-g -O0||' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "install failed"
	dodoc Changelog OBJECTIVES PORTABILITY PROTOCOL README TRICKS || die
}

src_test() {
	PATH="${D}/usr/bin:${PATH}" ./testbench.sh || die "tests failed"
}
