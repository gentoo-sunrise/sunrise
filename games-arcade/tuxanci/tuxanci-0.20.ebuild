# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games cmake-utils

DESCRIPTION="Tuxanci is first cushion shooter based on well-known Czech game Bulanci."
HOMEPAGE="http://www.tuxanci.org/"
SRC_URI="http://download.${PN}.org/${PV}/${P}-src.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="alsa dedicated"
# alsa is used only when building client

DEPEND="!dedicated? (
			>=media-libs/libsdl-1.2.10
			>=media-libs/sdl-ttf-2.0.7
			>=media-libs/sdl-image-1.2.6-r1
			alsa? (
				>=media-libs/sdl-mixer-1.2.7
			)
		)"

S="${WORKDIR}/pkgs/${P}-src/"

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

src_unpack() {
	unpack ${A}
	cd "${S}"
	# setting proper prefix
	sed -i \
		-e "s:PATH_DIR\tPREFIX:PATH_DIR:" src/base/path.h \
		|| die "sed config.h failed!"
	sed -i \
		-e "s:share/tuxanci:"${GAMES_DATADIR}"/"${PN}":" src/base/path.h \
		|| die "sed config.h failed!"
	sed -i \
		-e "s:CMAKE_INSTALL_DATADIR share/:CMAKE_INSTALL_DATADIR /usr/share/games/:" CMakeLists.txt \
		|| die "sed CMakeLists.txt failed!"
}

src_compile() {
	local mycmakeargs
	use alsa || mycmakeargs="${mycmakeargs} -DNO_Audio=1"
	use dedicated && mycmakeargs="${mycmakeargs} -DServer=1"
	mycmakeargs="${mycmakeargs} -DPREFIX=\\\"/usr/games\\\"	-DCMAKE_INSTALL_PREFIX:PATH=/usr/games"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

