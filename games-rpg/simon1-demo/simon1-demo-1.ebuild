# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="Simon the Sorcerer (interactive demo)"
HOMEPAGE="http://www.adventuresoft.com/gs1.html"
SRC_URI="http://gentooexperimental.org/~unlord/simon1demo_acorn.rar"

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
	doins DATA EFFECTS SIMON || die "doins failed"
	doins -r EXECUTE || die "doins -r failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" simon1"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Simon the Sorcerer 1 (Demo)" ${PN}.png

	prepgamesdirs
}
