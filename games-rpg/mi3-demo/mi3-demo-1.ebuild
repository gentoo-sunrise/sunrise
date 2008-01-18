# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="The Curse of Monkey Island (interactive demo)"
HOMEPAGE="http://www.lucasarts.com/products/monkey/default.htm"
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
	doins COMI.LA0 COMI.LA1 || die "doins failed"
	doins -r RESOURCE || die "doins -r failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" comi"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Monkey Island 3 (Demo)" ${PN}.png

	prepgamesdirs
}
