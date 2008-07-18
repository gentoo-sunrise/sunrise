# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_/-}

DESCRIPTION="Vi-like editor inspired by vim."
HOMEPAGE="http://www.yzis.org/"
SRC_URI="http://dl.freehackers.org/yzis/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/cmake"
RDEPEND=">=dev-lang/lua-5.1
	sys-libs/ncurses
	>=x11-libs/qt-4.1.0"


src_compile() {
	cmake -DENABLE_TESTS=OFF \
		-DENABLE_LIBYZISRUNNER=OFF \
		-DDCMAKE_BUILD_TYPE=Release \
		${MY_P} || die "CMake failed."

	emake || die "Build failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed."

	cd ${MY_P}
	dodoc ChangeLog README || die "dodoc failed."
}
