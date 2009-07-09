# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

MY_P=${P/_/-}

DESCRIPTION="Vi-like editor inspired by vim."
HOMEPAGE="http://www.yzis.org/"
SRC_URI="http://dl.freehackers.org/yzis/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DDEPEND=">=dev-lang/lua-5.1
	sys-libs/ncurses
	x11-libs/qt-gui:4"
RDEPEND="${RDEPEND}"

DOCS="ChangeLog README"

src_configure() {
	mycmakeargs="${mycmakeargs}  -DENABLE_TESTS=OFF \
		-DENABLE_LIBYZISRUNNER=OFF \
		-DDCMAKE_BUILD_TYPE=Release "
	cmake-utils_src_configure
}
