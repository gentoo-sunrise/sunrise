# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

MY_PN="LuxiMono"
DESCRIPTION="LuxiMono LaTeX Type1 typewriter font"
SRC_URI="http://dev.gentooexperimental.org/~dreeevil/${MY_PN}-${PV}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/fonts/LuxiMono/"
LICENSE="luximono"

IUSE=""
SLOT="0"
KEYWORDS="~x86"

DEPEND="app-arch/unzip"
RDEPEND=">=app-text/tetex-3.0"

S=${WORKDIR}/${MY_PN}

src_unpack(){
	unpack ${A}
	cd "${S}"
	unzip "${S}"/ul9.zip
}

src_install() {
	local PACK="luxi"
	local SUPPLIER="public"

#	latex-package_src_doinstall generally uses different
#	directories than this package expects
#	cd ${S}
#	latex-package_src_doinstall all

	cd "${S}"
	dodoc doc/fonts/luxi/* README.luximono

	insinto ${TEXMF}/fonts/map/dvips/${PACK}
	doins dvips/config/*

	insinto ${TEXMF}/fonts/afm/${SUPPLIER}/${PACK}
	doins *.afm

	insinto ${TEXMF}/fonts/tfm/${SUPPLIER}/${PACK}
	doins fonts/tfm/public/luxi/*.tfm

	insinto ${TEXMF}/fonts/vf/${SUPPLIER}/${PACK}
	doins fonts/vf/public/luxi/*.vf

	insinto ${TEXMF}/fonts/type1/${SUPPLIER}/${PACK}
	doins *.pfb

	insinto ${TEXMF}/tex/latex/${PACK}
	doins tex/latex/luxi/*

}

pkg_postinst() {
#	this order is intended
	latex-package_rehash
	updmap-sys --enable Map ul9.map
}

pkg_postrm() {
	updmap-sys --disable ul9.map
	latex-package_rehash
}
