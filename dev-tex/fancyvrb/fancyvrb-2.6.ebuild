# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="Sophisticated verbatim text"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/fancyvrb/"
SRC_URI="http://www.rennings.net/gentoo/distfiles/${P}.zip"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile() {
	latex-package_src_compile
	cd contrib
	latex-package_src_compile
}

src_install() {
	latex-package_src_install
	cd contrib
	latex-package_src_install
}
