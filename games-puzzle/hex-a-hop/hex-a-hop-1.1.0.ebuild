# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base eutils games

DESCRIPTION="A hexagonal tile-based puzzle game"
HOMEPAGE="http://hexahop.sourceforge.net/"
SRC_URI="mirror://sourceforge/hexahop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pango sound"

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	sound? ( media-libs/sdl-mixer[vorbis] )
	pango? ( media-libs/sdl-pango )
	!pango? ( media-libs/sdl-ttf )"

RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog )

src_configure() {
	# The build system is broken. Both --enable-sound and --disable-sound
	# disable sound. Both --enable-sdlttf and --disable-sdlttf disable sdlttf.
	egamesconf \
		--disable-debug \
		$(use !sound && echo --disable-sound) \
		$(use pango && echo --disable-sdlttf)
}

src_install () {
	base_src_install

	if ! use sound; then
		rm -f "${D}/${GAMES_DATADIR}"/*.ogg || die
	fi

	newicon data/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Hex-a-Hop /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
