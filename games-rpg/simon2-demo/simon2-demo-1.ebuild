# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="Simon the Sorcerer (interactive demo)"
HOMEPAGE="http://www.adventuresoft.com/gs2.html"
SRC_URI="http://gentooexperimental.org/~unlord/simon2demo.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.8.2"
DEPEND="|| (
	app-arch/unrar
	app-arch/rar )"

S=${WORKDIR}/simon2demo
dir=${GAMES_DATADIR}/${PN}

src_install() {
	insinto "${dir}"
	doins gsptr30 icon.dat simon2.gme simon2.voc stripped.txt tbllist || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" simon2"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Simon the Sorcerer 2 (Demo)" ${PN}.png

	prepgamesdirs
}
