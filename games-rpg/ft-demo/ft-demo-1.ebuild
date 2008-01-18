# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Full Throttle (Demo)"
HOMEPAGE="http://www.lucasarts.com/games/fullthrottle/"
SRC_URI="http://gentooexperimental.org/~unlord/ft-demo.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.8.2"
DEPEND="app-arch/unzip"

S=${WORKDIR}/ftdemo
dir=${GAMES_DATADIR}/${PN}

src_install() {
	insinto "${dir}"
	doins ft.{000,001} monster.sou || die "doins failed"
	doins -r data video || die "doins -r failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" ft"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Full Throttle (Demo)" ${PN}.png

	prepgamesdirs
}
