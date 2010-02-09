# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games toolchain-funcs

DESCRIPTION="snake like game"
HOMEPAGE="http://www.hs.no-ip.info/software/snake.html"
SRC_URI="http://www.hs.no-ip.info/software/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="
		media-libs/libsdl[alsa,X]
		media-libs/sdl-gfx
		media-libs/sdl-image[png]
		media-libs/sdl-mixer
		media-libs/sdl-ttf
"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{clean-up-Makefile,qa-warnings}.patch
}
src_compile() {
	emake CC=$(tc-getCXX) || die "emake failed"
}
src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	prepgamesdirs
}
