# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base multilib toolchain-funcs wxwidgets

DESCRIPTION="GUI to edit XServer-file xorg.conf easily"
HOMEPAGE="http://www.deesaster.org/progxorg.php"
SRC_URI="mirror://sourceforge/${PN}/${P}_src.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/wxGTK"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_compile() {
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" INSTALLPATH="/usr/$(get_libdir)" install \
		|| die "Installation failed"
	dodoc CHANGELOG README || die "dodoc failed"
}
