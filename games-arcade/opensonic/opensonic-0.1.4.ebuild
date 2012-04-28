# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils games

MY_PN=opensnc
MY_P=${MY_PN}-src-${PV}

DESCRIPTION="A free open-source game based on the Sonic the Hedgehog universe"
HOMEPAGE="http://opensnc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/allegro:0[X,jpeg,png,vorbis]
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libvorbis
	sys-libs/glibc
	sys-libs/zlib
	virtual/jpeg"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

CMAKE_VERBOSE=1

src_prepare() {
	epatch "${FILESDIR}"/${P}-cmake.patch
}

src_configure() {
	local mycmakeargs=(
		-DGAME_INSTALL_DIR="${GAMES_DATADIR}"/${PN}
		-DGAME_FINAL_DIR="${GAMES_BINDIR}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
