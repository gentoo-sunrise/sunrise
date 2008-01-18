# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3 eutils

DESCRIPTION="F4L is an open source development environment for Macromedia Flash"
HOMEPAGE="http://f4l.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="=x11-libs/qt-3*"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix gcc4.1 compatibility
	epatch "${FILESDIR}/${P}-gcc41.patch"
}

src_compile() {
	eqmake3 ${PN}.pro -o Makefile
	emake || die "emake failed"
}

src_install() {
	dobin bin/${PN}
	newicon src/cursor/main_ico1.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Flash for Linux" ${PN}.xpm Graphics
}
