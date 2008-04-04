# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit cmake-utils

DESCRIPTION="A graphical font manager"
HOMEPAGE="http://www.fontmatrix.net/"
SRC_URI="http://www.fontmatrix.net/archives/${P}-Source.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/qt-4.3:4
	=media-libs/freetype-2*"
RDEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/${P}-Source/"
