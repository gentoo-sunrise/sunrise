# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="a reimplementation of Sierra's Adventure Game Interpreter"
HOMEPAGE="http://www.dagii.org/"
SRC_URI="http://www.dagii.org/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc"
IUSE="png"

DEPEND="png? ( media-libs/libpng )
	media-libs/libsdl"
RDEPEND="${DEPEND}"

src_compile() {
	egamesconf $(use_enable png libpng ) || die "econf failed"
	emake dep || die "emake dep failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/${PN}
	dodoc README.txt
	doicon "${FILESDIR}/${PN}.xpm"
	make_desktop_entry ${PN} ${PN} ${PN}.xpm "Game;AdventureGame"
	prepgamesdirs
}

pkg_postinst() {
	elog "Dagii looks for games either in the user's current directory"
	elog "or in a location passed as a path in the command line"
	elog "For example: \"$ dagii /usr/share/games/kq3\""
	elog "Also, dagii can play games which are stored in .zip archives."
	echo
	games_pkg_postinst
}
