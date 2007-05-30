# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.4"

inherit games python

MY_PV=${PV//./}
MY_P=${PN}_b${MY_PV}
DESCRIPTION="A traditional and challenging 2D platformer game with a slight rotational twist"
HOMEPAGE="http://hectigo.net/puskutraktori/whichwayisup/"
SRC_URI="http://hectigo.net/puskutraktori/whichwayisup/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=dev-python/pygame-1.6"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:libdir\ =\ .*:libdir\ =\ \"$(games_get_libdir)/${PN}\":" \
		run_game.py || die "Changing library path failed"
	sed -i -e "s:data_dir\ =\ .*:data_dir\ =\ \"${GAMES_DATADIR}/${PN}\":" \
		lib/data.py || die "Changing data path failed"
}

src_install() {
	newgamesbin run_game.py ${PN} || die "newgamesbin failed"

	insinto "$(games_get_libdir)/${PN}"
	doins lib/*.py || die "doins lib failed"

	dodoc README.txt changelog.txt

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/* || die "doins data failed"

	doicon "${FILESDIR}/${PN}"-{32,48,64}.png
	make_desktop_entry ${PN} "Which Way Is Up" "${PN}"-64.png
	prepgamesdirs
}

pkg_postinst() {
	python_mod_optimize "$(games_get_libdir)/${PN}"
	games_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "$(games_get_libdir)/${PN}"
}
