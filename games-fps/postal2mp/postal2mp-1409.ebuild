# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils games multilib

DESCRIPTION="Postal 2: Share the Pain - Free Multiplayer Edition"
HOMEPAGE="http://icculus.org/news/news.php?id=4419"
SRC_URI="http://0day.icculus.org/postal2/Postal2STP-FreeMP-linux.tar.bz2 -> ${P}.tar.bz2"

LICENSE="postal2stp-freemp"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"
PROPERTIES="interactive"

RDEPEND="virtual/opengl
	amd64? ( app-emulation/emul-linux-x86-sdl )
	x86? (
		media-libs/libsdl[X,opengl]
		media-libs/openal
	)"

GAMES_CHECK_LICENSE="yes"

S=${WORKDIR}/Postal2STP-FreeMP-linux

src_install() {
	has_multilib_profile && ABI=x86

	dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r Animations KarmaData Maps Music Sounds \
		 StaticMeshes System Textures Web || die "doins failed"
	dosym /usr/$(get_libdir)/libopenal.so "${dir}"/System/openal.so || die
	dosym /usr/$(get_libdir)/libSDL-1.2.so.0 "${dir}"/System/libSDL-1.2.so.0 || die

	fperms +x "${dir}"/System/postal2-bin || die "fperms failed"

	games_make_wrapper ${PN} ./postal2-bin "${dir}"/System .
	newicon postal2.xpm ${PN}.xpm || die
	make_desktop_entry ${PN} "Postal 2 (Free MultiPlayer Ed.)"

	prepgamesdirs
}
