# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="LaTeX styles for (bilingual) critical editions typesetting."
SRC_URI="http://dev.gentooexperimental.org/~patrick/${P}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/ledmac/"
LICENSE="LPPL-1.3c"

IUSE=""
SLOT="0"
KEYWORDS="~x86"

RDEPEND="virtual/latex-base"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}
SUPPLIER="public"

src_install() {
	latex-package_src_doinstall sty
	dodoc *.pdf README || die "dodoc failed"
}
