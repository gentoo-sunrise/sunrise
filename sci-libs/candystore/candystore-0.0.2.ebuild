# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

MY_PN="CandyStore"

DESCRIPTION="CandyStore is a post processor for CalculiX"
HOMEPAGE="http://fe-candy.de"
SRC_URI="http://fe-candy.de/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="x11-libs/libqglviewer
	|| ( x11-libs/qt-gui >=x11-libs/qt-4.3 )"

S=${WORKDIR}/${MY_PN}

src_compile() {
	eqmake4 ${MY_PN}.pro -o Makefile PREFIX=/usr
	emake || die "emake failed"
}

src_install() {
	dobin ${MY_PN} || die "installation failed"

	if use doc ; then
		dohtml -r html/* || die "installing html files failed"
		docinto examples
		dodoc test-files/* || die "installing examples failed"
	fi
}
