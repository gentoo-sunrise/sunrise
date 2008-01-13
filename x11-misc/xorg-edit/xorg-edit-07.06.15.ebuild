# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WX_GTK_VER="2.6"
inherit eutils toolchain-funcs wxwidgets

DESCRIPTION="GUI to edit XServer-file xorg.conf easily"
HOMEPAGE="http://www.deesaster.org/progxorg.php"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="=x11-libs/wxGTK-2.6*
	x11-base/xorg-server"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin xorg-edit
	dodoc CHANGELOG README
}
