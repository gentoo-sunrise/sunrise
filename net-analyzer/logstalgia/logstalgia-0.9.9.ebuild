# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Replays or streams an access_log as a retro arcade game-like simulation"
HOMEPAGE="http://code.google.com/p/logstalgia/"
SRC_URI="http://logstalgia.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libpcre
	media-libs/libpng
	media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-image
	media-libs/ftgl
	virtual/jpeg"
RDEPEND="${DEPEND}"
