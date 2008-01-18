# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Broken Sword 2: The Smoking Mirror (interactive demo)"
HOMEPAGE="http://www.revolution.co.uk/_display.php?id=15"
SRC_URI="http://files.5star-network.com/Games/${PN}.zip
	ftp://ftp.planetmirror.com/pub/gameworld/demos/${PN}.zip
	http://gentooexperimental.org/~unlord/${PN}.zip
	mirror://sourceforge/scummvm/Sword2_Demo_Cutscenes.zip
	http://gentooexperimental.org/~unlord/Sword2_Demo_Cutscenes.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.10.0"
DEPEND="app-arch/unzip"

S=${WORKDIR}
dir=${GAMES_DATADIR}/${PN}

src_install() {
	insinto "${dir}"
	doins *.{clu,CLU,inf,tab,dxa,fla} || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" sword2demo"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Broken Sword 2 (Demo)" ${PN}.png

	prepgamesdirs
}
