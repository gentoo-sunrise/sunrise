# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils gnome2-utils games python-single-r1

DESCRIPTION="A computer mystery/romance game set five minutes into the future of 1988"
HOMEPAGE="http://scoutshonour.com/digital/"
SRC_URI="http://digital.artfulgamer.com/${P}.tar.bz2
	http://www.scoutshonour.com/lilyofthevalley/${P}.tar.bz2"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	games-engines/renpy:6.14[${PYTHON_USEDEP}]"

S=${WORKDIR}/Digital-linux-x86

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cat <<EOF >"${T}"/digital || die
#!/bin/sh -e
cd "${GAMES_DATADIR}/${PN}"
export PYTHONPATH="$(python_get_sitedir)/renpy614"
exec "${PYTHON}" Digital.py
EOF
}

src_install() {
	exeinto "${GAMES_BINDIR}"
	doexe "${T}"/digital

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r Digital.py common game renpy

	dohtml README.html

	newicon -s 128 game/icon.png ${PN}.png
	make_desktop_entry ${PN} "Digital: A love story"

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
