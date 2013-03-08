# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 cmake-utils

DESCRIPTION="A font manager"
HOMEPAGE="http://oep-h.com/fontmatrix/"
# old link dead, no official one yet ( Mar 21 2012 )
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/${PN}/${P}-Source.tar.gz/6a00c9448a50d3bab5acb4145f778f2d/${P}-Source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
	media-libs/freetype:2"
DEPEND=${RPEDEND}

S=${WORKDIR}/${P}-Source

src_configure() {
	local mycmakeargs="-DOWN_SHAPER=1"
	cmake-utils_src_configure
}

src_install() {
	dobin "${CMAKE_BUILD_DIR}"/src/${PN}
	doman ${PN}.1
	domenu ${PN}.desktop
	doicon ${PN}.png
	dodoc ChangeLog TODO
}

pkg_postinst() {
	elog "If you encounter problems or just have questions or if you have"
	elog "suggestions, please take time to suscribe to the undertype-users"
	elog "mailing list ( https://mail.gna.org/listinfo/undertype-users )."
	elog "If you want to reach us quickly, come to #fontmatrix at Freenode."
}
