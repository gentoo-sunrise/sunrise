# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

MY_P=${P/-/_}

DESCRIPTION="A mix from Nintendo's Super Mario Bros and Valve's Portal"
HOMEPAGE="http://stabyourself.net/mari0/"
SRC_URI="http://stabyourself.net/dl.php?file=${PN}-${PV/./00}/${PN}-source.zip
	-> ${P}.zip"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=games-engines/love-0.8.0
	 media-libs/devil[gif,png]"
DEPEND="app-arch/unzip"

src_install() {
	local dir="${GAMES_DATADIR}"/${PN}

	exeinto ${dir}
	doexe ${MY_P}.love || die

	doicon "${FILESDIR}"/${PN}.svg || die
	games_make_wrapper "${PN}" "love ${MY_P}.love" "${dir}"
	make_desktop_entry ${PN} ${PN} ${PN}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "${PN} savegames and configurations are stored in:"
	elog "~/.local/share/love/${PN}/"
}
