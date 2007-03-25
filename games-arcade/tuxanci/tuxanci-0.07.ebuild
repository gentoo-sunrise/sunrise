# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

inherit games toolchain-funcs

DESCRIPTION="First Cushion Shooter! A remake of well-known Czech game Bulanci."
SRC_URI="http://tuxanci.tuxportal.cz/releases/${P}.tar.bz2"
HOMEPAGE="http://tuxanci.tuxportal.cz"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-image
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# quick fix for English localization
	sed -i -e "s/End game/Quit!/" lang/en.lang || die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed."
	dodoc README ChangeLog
	prepgamesdirs
}
