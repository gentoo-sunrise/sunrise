# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Indiana Jones and the Fate of Atlantis (interactive demo)"
HOMEPAGE="http://www.theindyexperience.com/video_games/fate_of_atlantis_graphic_adventure.php"
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
	doins PLAYFATE.{000,001} || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" atlantis"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Indiana Jones and the Fate of Atlantis (Demo)" ${PN}.png

	prepgamesdirs
}
