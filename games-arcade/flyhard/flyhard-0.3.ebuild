# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="a game resembling Thrust, but with lots of shooting and puzzles"
HOMEPAGE="http://www.markboyd.me.uk/games/flyhard/flyhard.html"
SRC_URI="http://www.markboyd.me.uk/games/flyhard/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libpng
	media-libs/libsdl
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README NEWS TODO ChangeLog
	prepgamesdirs
}
