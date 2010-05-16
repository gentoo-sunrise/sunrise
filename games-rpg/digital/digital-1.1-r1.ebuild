# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

DESCRIPTION="A computer mystery/romance game set five minutes into the future of 1988"
HOMEPAGE="http://scoutshonour.com/digital/"
SRC_URI="http://digital.artfulgamer.com/${P}.tar.bz2
	http://www.scoutshonour.com/lilyofthevalley/${P}.tar.bz2"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-games/renpy:6.10"

S=${WORKDIR}/Digital-linux-x86

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r game/* || die

	games_make_wrapper ${PN} "renpy-6.10 '${GAMES_DATADIR}/${PN}'"

	newicon game/icon.png ${PN}.png || die
	make_desktop_entry ${PN} "Digital: A love story"

	dohtml README.html || die

	prepgamesdirs
}
