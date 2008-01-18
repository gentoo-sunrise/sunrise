# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games toolchain-funcs

DESCRIPTION="arcade-like boat racing game combining platform jumpers and elastomania / x-moto like games"
HOMEPAGE="http://bloboats.dy.fi/"
SRC_URI="http://mirror.kapsi.fi/bloboats.dy.fi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/sdl-net
	media-libs/libvorbis"
RDEPEND="${DEPEND}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/PREFIX/s://:${D}:" \
		-e "/DATADIR/s:/usr/games/bloboats/data:${GAMES_DATADIR}:" \
		-e "/BINARYDIR/s:/usr/bin:${GAMES_BINDIR}:" \
		-e "/CONFIGDIR/s:/etc:${GAMES_SYSCONFDIR}:" \
		-e "/CXXFLAGS_DEFAULT/s:-O2:${CXXFLAGS}:" \
		-e "/CXX_DEFAULT/s:g++:$(tc-getCXX):" \
		Makefile || die "sed Makefile failed"
}

src_install(){
	emake PREFIX="${D}" install || die "emake install failed"
	prepgamesdirs
}
