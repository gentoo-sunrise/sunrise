# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games subversion

DESCRIPTION="2D Game editor"
HOMEPAGE="http://game-editor.com"
ESVN_REPO_URI="https://game-editor.svn.sourceforge.net/svnroot/game-editor/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/libXext
	x11-libs/libxcb"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins gameEditor/res/* || die
	dogamesbin  output/editor/gameEditor || die
	prepgamesdirs
}
