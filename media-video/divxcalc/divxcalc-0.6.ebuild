# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="A simple MPEG-4 bitrate calculator used when ripping a DVD to achieve the ideal filesize."
HOMEPAGE="http://axllent.org/projects/divxcalc/files/"
SRC_URI="http://axllent.org/projects/${PN}/files/${P}.tar.bz2
	http://www.imagef1.net.nz/${PN}/${P}.tar.bz2
	http://mirror.dannz.net/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=x11-libs/qt-3*"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-build.patch"
	cp admin/acinclude.m4.in acinclude.m4
	eautoreconf
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
