# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils

MY_P=${P/_/-}

DESCRIPTION="Vi-like editor inspired by vim"
HOMEPAGE="http://www.yzis.org/"
SRC_URI="http://labs.freehackers.org/attachments/download/45/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-doc/doxygen
	>=dev-lang/lua-5.1
	sys-libs/ncurses
	dev-qt/qtgui:4
	dev-qt/qttest:4
	"
RDEPEND="${DEPEND}"

DOCS="ChangeLog README"

S="${WORKDIR}/${MY_P}"

src_configure() {
	mycmakeargs="${mycmakeargs}  -DENABLE_TESTS=OFF \
		-DENABLE_LIBYZISRUNNER=OFF \
		-DDCMAKE_BUILD_TYPE=Release "
	cmake-utils_src_configure
}
