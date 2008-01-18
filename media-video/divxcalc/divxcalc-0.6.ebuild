# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A simple MPEG-4 bitrate calculator used when ripping a DVD to achieve the ideal filesize."
HOMEPAGE="http://axljab.homelinux.org/DivXcalc"
SRC_URI="http://www.imagef1.net.nz/${PN}/${P}.tar.bz2
	http://mirror.dannz.net/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=x11-libs/qt-3*"
DEPEND="${RDEPEND}"

src_compile() {
	emake -f Makefile.dist
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README
}
