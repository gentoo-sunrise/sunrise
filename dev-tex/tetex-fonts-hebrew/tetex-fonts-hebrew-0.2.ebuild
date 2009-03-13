# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="adds culmus fonts support for hebrew documents in LaTeX."
HOMEPAGE="http://ivritex.sourceforge.net/"
SRC_URI="mirror://sourceforge/ivritex/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/latex-base"
DEPEND="${RDEPEND}
		media-fonts/culmus"

S=${WORKDIR}/${PN}

src_compile() {
	emake CULMUSDIR=/usr/share/fonts/culmus/ || die "Compile Failed!"
}

src_install() {
	#I'm using pkginstall instead of regular install to avoid sandbox
	#violations caused by running mktexlsr and updmap
	emake CULMUSDIR=/usr/share/fonts/culmus/ \
		TEXMFDIR="${D}/usr/share/texmf/" pkginstall \
		|| die "Install Failed!"

	dodoc README || die "dodoc failed"
}

pkg_postinst() {
	mktexlsr
	updmap-sys --enable Map=culmus.map
}

pkg_postrm() {
	mktexlsr
	updmap-sys --disable culmus.map
}
