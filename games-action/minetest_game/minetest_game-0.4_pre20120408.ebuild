# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2 games

DESCRIPTION="Building single/multiplayer game (game)"
HOMEPAGE="http://c55.me/minetest/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/celeron55/${PN}.git"
EGIT_COMMIT="${PV%_pre*}.dev-${PV#*_pre}"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-action/minetest"
DEPEND="${RDEPEND}"

src_unpack() {
	git-2_src_unpack
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN%_game}/games/${PN}
	doins -r mods || die
	doins game.conf || die

	prepgamesdirs
}
