# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="snake like game"
HOMEPAGE="http://www.hs.no-ip.info/software/snake.html"
SRC_URI="http://www.hs.no-ip.info/software/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="
		media-libs/libsdl[alsa]
		media-libs/sdl-gfx
		media-libs/sdl-image[png]
		media-libs/sdl-mixer
		media-libs/sdl-ttf
"
RDEPEND=${DEPEND}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	prepgamesdirs
}
