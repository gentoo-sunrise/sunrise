# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils qt4

DESCRIPTION="A font manager"
HOMEPAGE="http://www.fontmatrix.net/"
SRC_URI="http://www.fontmatrix.net/archives/${P}-Source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="|| ( ( x11-libs/qt-core:4 x11-libs/qt-gui:4 x11-libs/qt-svg:4 )
	>=x11-libs/qt-4.3:4 )
	>=media-libs/freetype-2"

S=${WORKDIR}/${P}-Source
B=${WORKDIR}/${PN}_build

src_compile() {
	local mycmakeargs="-DOWN_SHAPER=1"
	cmake-utils_src_compile
	cd "${B}"
	emake || die "emake failed"
}

src_install() {
	dobin "${B}"/src/${PN} || die
	doicon "${S}/${PN}.png"
	make_desktop_entry ${PN} "Fontmatrix" ${PN}.png
}

pkg_postinst() {
	elog "If you encounter problems or just have questions or if you have"
	elog " suggestions, please take time to suscribe to the undertype-users"
	elog " mailing list ( https://mail.gna.org/listinfo/undertype-users )."
	elog " If you want to reach us quickly, come to #fontmatrix at Freenode."
}
