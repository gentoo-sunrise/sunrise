# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3

DESCRIPTION="Editor for manipulating PDF documents. GUI and commandline interface."
HOMEPAGE="http://pdfedit.petricek.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
RDEPEND="=x11-libs/qt-3*
	media-libs/t1lib"
DEPEND="${RDEPEND}
	dev-libs/boost
	doc? ( app-doc/doxygen )"

src_compile(){
	econf $(use_enable doc doxygen-doc) $(use_enable doc advanced-doc)
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
