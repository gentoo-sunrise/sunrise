# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Produces drawings of two- or three-dimensional solid objects and scenes for TeX"
HOMEPAGE="http://www.frontiernet.net/~eugene.ressler/"
SRC_URI="http://www.frontiernet.net/~eugene.ressler/${P}.tgz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="dev-lang/perl"
RDEPEND=""

src_install() {
	dobin sketch || die
	edos2unix Doc/sketch.info
	doinfo Doc/sketch.info || die
	if use doc ; then
		dodoc Doc/sketch.pdf || die
		dohtml Doc/sketch/* || die
	fi
}