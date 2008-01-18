# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="mimetex lets you easily embed LaTeX math in your html and dynamic web pages"
HOMEPAGE="http://www.forkosh.dreamhost.com/mimetex.html"
SRC_URI="http://www.forkosh.com/${PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_compile() {
	$(tc-getCC) ${CFLAGS} -DAA -o ${PN} mimetex.c gifsave.c -lm \
		|| die "compile failed!"
}

src_install() {
	dobin ${PN}
}
