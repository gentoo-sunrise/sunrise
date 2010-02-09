# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit games

DESCRIPTION="a game cheater for GNU/Linux that uses ptrace system call to edit processes' memory"
HOMEPAGE="http://gamecheater.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="gnome-base/libglade
	dev-libs/glib:2
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog README || die "dodoc failed"
	make_desktop_entry "${PN}" "Game Cheater" "${GAMES_DATADIR}/${PN}/pixmaps/${PN}.png"
	prepgamesdirs
}
