# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Sam & Max Hit the Road (interactive demo)"
HOMEPAGE="http://www.samandmax.net/?section=hittheroad"
SRC_URI="http://gentooexperimental.org/~unlord/${PN}.rar"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.8.2"
DEPEND="|| (
	app-arch/unrar
	app-arch/rar )"

S=${WORKDIR}
dir=${GAMES_DATADIR}/${PN}

src_install() {
	insinto "${dir}"
	doins SNMDEMO.{SM0,SM1} MONSTER.SOU || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" samnmax"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Sam & Max Hit the Road (Demo)" ${PN}.png

	prepgamesdirs
}
