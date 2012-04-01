# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Replays or streams an access_log as a retro arcade game-like simulation"
HOMEPAGE="http://code.google.com/p/logstalgia/"
SRC_URI="http://logstalgia.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="media-libs/mesa
	dev-libs/libpcre
	media-libs/libsdl[opengl]
	media-libs/sdl-image
	media-libs/ftgl"

RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install
}
