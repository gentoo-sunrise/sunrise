# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="This package enables to generate multilingual bibliographies in cooperation with babel."
HOMEPAGE="http://tug.ctan.org/tex-archive/biblio/bibtex/contrib/babelbib/"
#As it seems that CTAN has no versioned packages I mirrored it on my private webspace
SRC_URI="http://www.rennings.net/gentoo/distfiles/${P}.zip"

LICENSE="LPPL-1.3b"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	latex-package_src_doinstall sty
	latex-package_src_doinstall bst
	latex-package_src_doinstall bdf

	insinto "${TEXMF}/tex/latex/${PN}"
	for i in $(find . -maxdepth 1 -type f -name "*.bdf")
	do
		doins $i || die "doins $i failed"
	done

	dodoc README ChangeLog babelbibtest.tex babelbibtest.bib

	insinto /usr/share/doc/${PF}
	doins *.pdf
}
