# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Broken Sword 1: The Shadow of the Templars (interactive demo)"
HOMEPAGE="http://www.revolution.co.uk/_display.php?id=14"
SRC_URI="http://gentooexperimental.org/~unlord/bs1-demo.rar
	http://gentooexperimental.org/~unlord/bs1-demo-cutscenes.rar"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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
	doins SWORD_INSTALL/CLUSTERS/*.{CLU,RIF} video/*.{mp2,ogg} || die "doins failed"
	doins -r SWORD_INSTALL/{MUSIC,SPEECH} || die "doins -r failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" sword1demo"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Broken Sword 1 (Demo)" ${PN}.png

	prepgamesdirs
}
