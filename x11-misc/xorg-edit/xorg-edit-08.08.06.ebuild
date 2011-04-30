# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

WX_GTK_VER="2.8"

inherit base multilib toolchain-funcs wxwidgets

DESCRIPTION="GUI to edit XServer-file xorg.conf easily"
HOMEPAGE="http://www.deesaster.org/progxorg.php"
SRC_URI="mirror://sourceforge/${PN}/${P}_src.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/wxGTK:2.8[X]"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	emake DESTDIR="${D}" INSTALLPATH="/usr/$(get_libdir)" install
	dodoc CHANGELOG README
}
