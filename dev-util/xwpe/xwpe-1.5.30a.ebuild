# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI=2

inherit base

DESCRIPTION="Programming environment mimicking Borland C and Pascal"
HOMEPAGE="http://www.identicalsoftware.com/xwpe/"
SRC_URI="http://www.identicalsoftware.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X"

DEPEND="sys-libs/ncurses
	sys-libs/gpm
	sys-libs/zlib
	X? ( x11-libs/libX11 )"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-destdir.patch" )

src_configure() {
	econf $(use_with X x)
}
