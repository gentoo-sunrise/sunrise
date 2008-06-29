# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_P=${P/_/}

DESCRIPTION="First Cushion Shooter! A remake of well-known Czech game Bulanci."
HOMEPAGE="http://tuxanci.tuxportal.cz"
SRC_URI="http://tuxanci.tuxportal.cz/releases/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.7
	media-libs/sdl-ttf
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
GAMES_USE_SDL="noaudio"

pkg_setup() {
	games_pkg_setup

	if ! built_with_use media-libs/sdl-image png ; then
		eerror "media-libs/sdl-image is missing png support."
		die "Recompile media-libs/sdl-image with USE=\"png\""
	fi

	if ! built_with_use media-libs/sdl-mixer vorbis ; then
		eerror "media-libs/sdl-mixer is missing vorbis support."
		die "Recompile media-libs/sdl-mixer with USE=\"vorbis\""
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed."
	dodoc README ChangeLog
	prepgamesdirs
}
