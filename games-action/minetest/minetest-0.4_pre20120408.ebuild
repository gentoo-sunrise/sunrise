# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils git-2 games

DESCRIPTION="Building single/multiplayer game (engine)"
HOMEPAGE="http://c55.me/minetest/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/celeron55/${PN}.git"
EGIT_COMMIT="${PV%_pre*}.dev-${PV#*_pre}"

LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"

KEYWORDS=""
IUSE="+client nls +server"

RDEPEND="app-arch/bzip2
	dev-db/sqlite:3
	dev-lang/lua
	>=dev-libs/jthread-1.2
	media-libs/libpng:0
	media-libs/libvorbis
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXxf86vm
	virtual/jpeg
	virtual/opengl
	nls? ( virtual/libintl )
	"
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.7
	nls? ( sys-devel/gettext )
	"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{cmake,jthread,lua,sharepath}.patch
	rm -r src/{jthread,lua,sqlite} || die
}

src_configure() {
	local mycmakeargs=(
		-DRUN_IN_PLACE=0
		-DSHAREDIR="${GAMES_DATADIR}/${PN}"
		-DBINDIR="${GAMES_BINDIR}"
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build server SERVER)
		$(cmake-utils_use_enable nls GETTEXT)
		)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
