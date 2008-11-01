# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="LaTeX package to typeset SI units, numbers and angles."
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/SIstyle/"
SRC_URI="http://www.rennings.net/gentoo/distfiles/${P}.zip"

LICENSE="LPPL-1.3b"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}/source/latex/SIstyle/figs"
	unpack ./graphs_scr.zip
}

src_install() {
	cd "${S}/tex/latex/SIstyle"
	latex-package_src_install
	cd "${S}/doc/latex/SIstyle"
	latex-package_src_install

	cd "${S}/source/latex/SIstyle"
	insinto "${TEXMF}/source/latex/SIstyle"
	doins sistyle.dtx sistyle.ins
	doins figs/fig{1,2}.*ps
	cd figs/graphs_scr
	insinto "${TEXMF}/source/latex/SIstyle/graphs_src"
	doins *.mp MPfig.bat readme_figs.txt *.m
}
