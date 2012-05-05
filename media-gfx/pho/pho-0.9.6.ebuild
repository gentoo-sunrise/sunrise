# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="GTK image viewer"
HOMEPAGE="http://shallowsky.com/software/pho/"
SRC_URI="http://shallowsky.com/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e "s:-g -O -Wall:${CFLAGS}:" Makefile\
		|| die "sed fix of cflags failed"
	sed -i -e "s:-Wall -g -O2:${CFLAGS}:" exif/Makefile\
		|| die "sed fix of cflags2 failed"
	tc-export CC
}

src_install() {
	dobin pho || die "installation failed"
	doman pho.1
}
