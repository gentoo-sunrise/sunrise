# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

MY_PV="r${PV%_*}-alpha"
MY_PN=${PN%-data}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="Data files for 0ad"
HOMEPAGE="http://wildfiregames.com/0ad/"
SRC_URI="mirror://sourceforge/zero-ad/${MY_P}-unix-data.tar.xz"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto "${GAMES_DATADIR}"/${MY_PN}
	doins -r binaries/data/* || die
	prepgamesdirs
}
