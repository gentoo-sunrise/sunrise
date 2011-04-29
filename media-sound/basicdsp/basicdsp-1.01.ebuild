# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

WX_GTK_VER="2.8"

inherit eutils toolchain-funcs wxwidgets

DESCRIPTION="A program for experimenting with simple audio DSP algorithms"
HOMEPAGE="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/basicdsp/"
SRC_URI="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}/${P}.tgz
	doc? ( http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}/BasicDSP_SPRAT.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="x11-libs/wxGTK:2.8[X]"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/makefile.patch
	tc-export CXX
}

src_install() {
	dobin basicdsp || die "dobin failed"
	doman basicdsp.1 || die "doman failed"
	dodoc README.txt || die "dodoc failed"
	if use doc ; then
		dodoc "${DISTDIR}"/BasicDSP_SPRAT.pdf || die "dodoc failed"
	fi
}
