# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils flag-o-matic games

DESCRIPTION="An open source reimplementation of TES III: Morrowind"
HOMEPAGE="http://openmw.org/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-source.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mp3 ffmpeg"

RDEPEND=">=dev-games/ogre-1.7.0[cg,ois]
	dev-games/ois
	>=dev-libs/boost-1.46.0
	media-gfx/nvidia-cg-toolkit
	media-libs/freetype:2
	media-libs/openal
	sci-physics/bullet
	>=dev-libs/qtgui-4.7.0:4
	mp3? (
		ffmpeg? ( media-video/ffmpeg[mp3] )
		!ffmpeg? ( media-libs/libsndfile
			media-sound/mpg123 )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}-source

src_prepare() {
	epatch "${FILESDIR}"/${P}-cmake.patch

	sed \
		-e "s#globalPath(\"/etc/\")#globalPath(\"${GAMES_SYSCONFDIR}\")#" \
		-i components/files/linuxpath.cpp || die
}

src_configure() {
	# QA
	append-flags -fno-strict-aliasing

	local mycmakeargs
	if use mp3 ; then
		use ffmpeg && mycmakeargs="-DUSE_FFMPEG=ON" || \
			mycmakeargs="-DUSE_MPG123=ON"
	fi

	mycmakeargs+=(
		-DBINDIR="${GAMES_BINDIR}"
		-DDATADIR="${GAMES_DATADIR}"/${PN}
		-DSYSCONFDIR="${GAMES_SYSCONFDIR}"/${PN}
		-DUSE_AUDIERE=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc readme.txt || die
	prepgamesdirs
}
