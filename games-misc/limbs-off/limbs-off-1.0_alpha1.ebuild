# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools git-2 games

DESCRIPTION="Gratis Free Software fighting game"
HOMEPAGE="http://plaimi.net/games/"
EGIT_REPO_URI="https://github.com/stiell/${PN}.git
    git://github.com/stiell/${PN}.git"
EGIT_COMMIT="4c169036ab2ac1bbd3bab992414a6838090f31a9"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/fontconfig
	media-libs/libpng:0
	media-libs/libsdl
	media-libs/sdl-ttf
	virtual/opengl
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-icondir=/usr/share/pixmaps \
		--with-desktopdir=/usr/share/applications
}

src_install() {
	dodoc HACKING TODO || die
	emake DESTDIR="${D}" install || die
	prepgamesdirs
}
