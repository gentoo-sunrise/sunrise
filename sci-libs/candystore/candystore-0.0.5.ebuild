# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

MY_PN="CandyStore"

DESCRIPTION="CandyStore is a post processor for CalculiX"
HOMEPAGE="http://fe-candy.de"
SRC_URI="http://fe-candy.de/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="x11-libs/qt-gui:4"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_PN}

src_configure() {
	eqmake4 ${MY_PN}.pro -o Makefile PREFIX=/usr
}

src_install() {
	dobin ${MY_PN} || die "installation failed"

	if use doc ; then
		dohtml -r html/* || die "installing html files failed"
		docinto examples
		dodoc test-files/* || die "installing examples failed"
	fi
}
