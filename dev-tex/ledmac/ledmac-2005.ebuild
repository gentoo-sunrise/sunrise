# Copyright 1999-2008 Gentoo Foundation
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

RDEPEND=">=app-text/tetex-3.0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}
SUPPLIER="public"

src_compile() {
	latex ledmac.ins
	latex ledpar.ins
	latex ledarab.ins
}

src_install() {
	latex-package_src_doinstall sty
	dodoc *pdf README
}

pkg_postinst() {
	latex-package_rehash
}

pkg_postrm() {
	latex-package_rehash
}
