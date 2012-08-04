# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games

DESCRIPTION="A NES-like platform arcade game"
HOMEPAGE="http://remar.se/andreas/retrobattle/"
SRC_URI="${HOMEPAGE}files/${PN}-src-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	media-libs/libsdl[X,audio,video]
	media-libs/sdl-mixer
	"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-src-${PV}/src/

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${WORKDIR}"/${PN}-src-${PV}/data

	newgamesbin "${WORKDIR}"/${PN}-src-${PV}/${PN} ${PN}.bin
	games_make_wrapper ${PN} "${PN}.bin \"${GAMES_DATADIR}/${PN}\""
	make_desktop_entry ${PN} &{PN} ""

	dodoc "../manual.txt" "../README"

	prepgamesdirs
}
