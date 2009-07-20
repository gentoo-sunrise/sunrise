# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Graphical front-end for cuneiform OCR tool"
HOMEPAGE="http://symmetrica.net/cuneiform-linux/yagf-en.html"
SRC_URI="http://symmetrica.net/cuneiform-linux/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scanner"

DEPEND="x11-libs/qt-gui:4
		app-text/aspell"

RDEPEND="${DEPEND}
	app-text/cuneiform
	scanner? ( media-gfx/xsane )"

DOCS="DESCRIPTION README"

CMAKE_IN_SOURCE_BUILD=1
