# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils git-2

DESCRIPTION="Gratis Free Software fighting game"
HOMEPAGE="http://plaimi.net/games/"
EGIT_REPO_URI="git://github.com/stiell/limbs-off.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/fontconfig
	media-libs/libpng
	media-libs/libsdl
	media-libs/sdl-ttf
	virtual/opengl
	"

src_prepare() {
	eautoreconf
}

src_install() {
	default
	dodoc HACKING TODO
}
