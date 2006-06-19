# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Another Modeline Calculator. Generates quality X11 display configs easily."
HOMEPAGE="http://amlc.berlios.de"
SRC_URI="http://amlc.berlios.de/src/${P}.cpp"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/${P}.cpp ${S}
}

src_compile() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} ${S}/${P}.cpp -o amlc -Os -Wall -pedantic
}

src_install() {
	dobin amlc
}
