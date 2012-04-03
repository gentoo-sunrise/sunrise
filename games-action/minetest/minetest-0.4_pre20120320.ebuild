# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils games

DESCRIPTION="Building single/multiplayer game"
HOMEPAGE="http://c55.me/minetest/"
SRC_URI="https://github.com/celeron55/${PN}/tarball/${PV%_pre*}.dev-${PV#*_pre} ->
	${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="+client nls +server"

DEPEND="app-arch/bzip2
	dev-db/sqlite:3
	>=dev-games/irrlicht-1.7
	>=dev-libs/jthread-1.2
	media-libs/libpng
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXxf86vm
	virtual/jpeg
	virtual/opengl
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/celeron55-${PN}-94f1ab4

src_prepare() {
	epatch "${FILESDIR}"/${P}-cmake.patch \
		"${FILESDIR}"/${P}-sharepath.patch
}

src_configure() {
	local mycmakeargs=(
		-DRUN_IN_PLACE=0
		-DSHAREDIR="${GAMES_DATADIR}/${PN}"
		-DBINDIR="${GAMES_BINDIR}"
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build server SERVER)
		$(cmake-utils_use_use nls GETTEXT)
		)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
