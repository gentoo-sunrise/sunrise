# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="A nodebuilder and REJECT builder for DooM engine games"
HOMEPAGE="http://www.mrousseau.org/programs/ZenNode/"
SRC_URI="http://www.mrousseau.org/programs/ZenNode/archives/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/ZenNode-${PV}/src/ZenNode

src_unpack() {
	unpack ${A}
	cd ZenNode-${PV}
	unpack ./zennode-src.zip
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dogamesbin ZenNode bspdiff bspinfo compare
	cd ../../doc
	dohtml Custom.html History.html Overview.html README.html RMB.html \
		bspdiff.html bspinfo.html compare.html index.html main.css manual.html
	prepgamesdirs
}
