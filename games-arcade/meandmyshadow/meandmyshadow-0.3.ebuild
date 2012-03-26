# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games cmake-utils eutils

DESCRIPTION="A puzzle/platform game with a player and its shadow"
HOMEPAGE="http://meandmyshadow.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-2.5 CCPL-Attribution-ShareAlike-3.0 GPL-3 OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/libarchive
	dev-libs/openssl:0
	media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	net-misc/curl"
RDEPEND="${DEPEND}"

src_prepare() {
	edos2unix CMakeLists.txt src/config.h.in
	epatch "${FILESDIR}"/${P}-cmake.patch
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DMEANDMYSHADOW_EXECUTABLE_DIR="${GAMES_BINDIR#/usr/}"
		-DMEANDMYSHADOW_DATA_DIR="${GAMES_DATADIR#/usr/}"
		)
	cmake-utils_src_configure
}
