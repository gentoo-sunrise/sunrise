# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="TeX-to-MathML converter"
HOMEPAGE="http://gva.noekeon.org/blahtexml"
SRC_URI="http://gva.noekeon.org/${PN}/${P}-src.tar.gz"

# Manual licensed under CCPL
LICENSE="BSD CCPL-Attribution-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="dev-libs/xerces-c"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/texlive-core
		dev-libs/libxslt
		dev-tex/latex2html )"

src_prepare() {
	tc-export CC CXX
	epatch "${FILESDIR}"/${P}-{Makefile,gcc-4.7}.patch
}

src_compile() {
	emake blahtex{,ml}-linux
	use doc && emake doc
}

src_install() {
	dobin blahtex ${PN}
	doman "${FILESDIR}/${PN}.1"
	use doc && dodoc Documentation/manual.pdf
}
