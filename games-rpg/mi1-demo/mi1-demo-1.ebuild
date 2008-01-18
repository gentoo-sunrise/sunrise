# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="The Secret of Monkey Island (interactive demo)"
HOMEPAGE="http://www.worldofmi.com/thegames/monkey1/"
SRC_URI="http://gentooexperimental.org/~unlord/${PN}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.8.2"
DEPEND="app-arch/unzip"

S=${WORKDIR}
dir=${GAMES_DATADIR}/${PN}

src_install() {
	insinto "${dir}"
	doins *.{LEC,LFL} || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" monkey"
	doicon "${FILESDIR}/${PN}.png" || die "newicon failed"
	make_desktop_entry ${PN} "Monkey Island 1 (Demo)" ${PN}.png

	prepgamesdirs
}
