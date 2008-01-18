# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games distutils

DESCRIPTION="A graphical and text-based sudoku game"
HOMEPAGE="http://pythonsudoku.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-python/pygtk
	dev-python/reportlab
	dev-python/imaging"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's#\(syscfg[ \t]*\)=.*#\1= /etc/games/pythonsudoku/pysdk.cfg#' \
		-e 's#\(install-scripts[ \t]*\)=.*#\1= /usr/games/bin#' \
		pythonsudoku/platform.cfg setup.cfg || die "fixing configfile path failed"
}

src_install() {
	newgamesbin pysdk.py pysdk || die "newgamesbin failed"
	distutils_src_install

	dohtml -r doc/*
	doman doc/pysdk.6
	dodoc doc/*.txt

	prepgamesdirs

	insinto /etc/games/pythonsudoku
	doins pysdk.cfg
}
