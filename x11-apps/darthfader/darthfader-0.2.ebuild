# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An utility to show a fading text for X. Similar to windowmaker's effect when changing workspace."
SRC_URI="http://cs.joensuu.fi/~agrohn/darthfader/${P}.tar.gz"
HOMEPAGE="http://cs.joensuu.fi/~agrohn/darthfader/"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libX11
	x11-libs/libXext"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:CF=:CF=${CFLAGS}:' \
		-e 's:/usr/X11R6:/usr:g' Makefile
}

src_install () {
	dobin dfade
	dolib libdarthfader.so
	dodoc README
}
