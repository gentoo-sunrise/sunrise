# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GTK image viewer"
HOMEPAGE="http://shallowsky.com/software/pho/"
SRC_URI="http://shallowsky.com/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc"
IUSE=""

DEPEND="dev-util/pkgconfig
	x11-libs/gtk+"
RDEPEND="x11-libs/gtk+"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:-g -O -Wall:${CFLAGS}:" Makefile\
		|| die "sed fix of cflags failed"
	sed -i -e "s:-Wall -g -O2:${CFLAGS}:" exif/Makefile\
		|| die "sed fix of cflags2 failed"
}

src_install() {
	dobin pho || die "installation failed"
	doman pho.1
}
