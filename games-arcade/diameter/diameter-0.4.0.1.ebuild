# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

MY_PN="game${PN}"

DESCRIPTION="an arcade-style game with elements of economy and adventure."
HOMEPAGE="http://gamediameter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-games/guichan
	media-libs/libpng
	media-libs/libsdl
	>=media-libs/sdl-image-1.2.4
	media-libs/sdl-mixer"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_PN}

pkg_setup() {
	games_pkg_setup

	if ! built_with_use "dev-games/guichan" opengl \
		|| ! built_with_use "dev-games/guichan" sdl ; then
		eerror "${PN} needs dev-games/guichan compiled with USE=\"opengl sdl\"."
		die "dev-games/guichan without USE=\"opengl sdl\""
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "/^CFLAGS=.*march/ d" \
		-e "s/gamediameter/diameter/g" configure || die "sed configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon data/texture/gui/eng/main/logo.png ${PN}.png
	make_desktop_entry ${PN} "Diameter" ${PN}.png "Game;ArcadeGame"
	dodoc README NEWS
	prepgamesdirs
}
