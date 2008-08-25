# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="1"
inherit qt4

DESCRIPTION="Wally is a QT4 wallpaper changer"
HOMEPAGE="http://wally.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-1"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=media-libs/libexif-0.6
	media-libs/libpng
	x11-libs/qt-core:4
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_compile() {
	eqmake4
	emake || die "Make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
