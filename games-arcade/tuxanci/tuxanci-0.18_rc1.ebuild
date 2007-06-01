# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

MY_P=${P/_/}

DESCRIPTION="First Cushion Shooter! A remake of well-known Czech game Bulanci."
SRC_URI="http://tuxanci.tuxportal.cz/releases/${MY_P}.tar.bz2"
HOMEPAGE="http://tuxanci.tuxportal.cz"

KEYWORDS="~x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT="0"

DEPEND="media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-image
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed."
	dodoc README ChangeLog
	prepgamesdirs
}
