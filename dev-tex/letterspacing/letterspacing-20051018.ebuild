# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="TeX package for letter spacing"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/generic/misc/"
SRC_URI="ftp://tug.ctan.org/pub/tex-archive/macros/generic/misc/${PN}.tex"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="virtual/tetex"
S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${PN}.tex" "${S}"
}

src_install() {
	insinto ${TEXMF}/tex/generic/${PN}
	doins letterspacing.tex
	dosym letterspacing.tex ${TEXMF}/tex/generic/${PN}/letterspace.sty
}
