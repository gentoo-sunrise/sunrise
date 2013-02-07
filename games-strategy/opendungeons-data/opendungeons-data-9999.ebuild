# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit subversion games

MY_PN=${PN%-data}

DESCRIPTION="Data files for opendungeons"
HOMEPAGE="http://opendungeons.sourceforge.net"
ESVN_REPO_URI="https://${MY_PN}.svn.sourceforge.net/svnroot/${MY_PN}/media"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

src_unpack() {
	subversion_src_unpack
}

src_install() {
	insinto "${GAMES_DATADIR}"/OpenDungeons
	doins -r * || die

	prepgamesdirs
}
