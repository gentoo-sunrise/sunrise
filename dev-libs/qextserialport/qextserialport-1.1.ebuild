# Copyright 2011-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-r2

DESCRIPTION="cross-platform serial port class"
HOMEPAGE="http://code.google.com/p/qextserialport/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="x11-libs/qt-core:4"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
)

src_configure() {
	eqmake4 "${S}"/qextserialport/qextserialport.pro
}

src_install() {
	qt4-r2_src_install
	if use doc ; then
		dohtml -r "${S}"/qextserialport/html/* || die
	fi
}
