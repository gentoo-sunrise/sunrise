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
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-mixer
	"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-src-${PV}/src/

src_install() {
	emake RETROINSTALLDIR="${D}/${GAMES_DATADIR}" install || die "emake failed"
	prepgamesdirs
	# Following games.eclass the binary should be in /usr/games/bin/
	dosym "${GAMES_DATADIR}/${PN}/${PN}" "${GAMES_PREFIX}/bin/${PN}" || die "dosym failed"
	dodoc "../manual.txt" "../README"
}
