# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="A 2d soccer game"
HOMEPAGE="http://tuxfootball.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/sdl-mixer
		media-libs/sdl-image
		media-libs/libsdl"
DEPEND="dev-util/intltool
		sys-devel/gettext
		${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
	make_desktop_entry ${PN} Tuxfootball
	prepgamesdirs
}
