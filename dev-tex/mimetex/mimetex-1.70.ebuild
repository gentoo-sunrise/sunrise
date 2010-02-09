# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="mimetex lets you easily embed LaTeX math in your html and dynamic web pages"
HOMEPAGE="http://www.forkosh.dreamhost.com/mimetex.html"
# forkosh.com only provide mimetex.zip file that is breaking everything when
# their is a version bump. I've hosted currente release into my server (volkmar)
#SRC_URI="http://www.forkosh.com/${PN}.zip"
SRC_URI="http://gentoo.oldworld.fr/distfiles/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_compile() {
	$(tc-getCC) ${CFLAGS} -DAA -o ${PN} mimetex.c gifsave.c -lm \
		|| die "compilation failed"
}

src_install() {
	dobin ${PN}.cgi || die "installation failed"
}
