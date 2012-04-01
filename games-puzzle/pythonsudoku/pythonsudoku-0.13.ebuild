# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit games distutils

DESCRIPTION="A graphical and text-based sudoku game"
HOMEPAGE="http://pythonsudoku.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-python/pygtk
	dev-python/reportlab
	dev-python/imaging"

src_prepare() {
	sed \
		-e "s:/usr/games:/usr/games/bin:g" \
		-i setup.cfg || die
}

src_install() {
	newgamesbin pysdk.py pysdk || die "newgamesbin failed"
	distutils_src_install

	dohtml -r doc/* || die
	doman doc/pysdk.6 || die
	dodoc doc/*.txt || die

	prepgamesdirs

	insinto /etc/games/pythonsudoku
	doins pysdk.cfg || die
}
