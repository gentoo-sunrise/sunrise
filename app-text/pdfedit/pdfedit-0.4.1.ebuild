# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Editor for manipulating PDF documents. GUI and commandline interface."
HOMEPAGE="http://pdfedit.petricek.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="=x11-libs/qt-3*"
DEPEND="${RDEPEND}
	dev-libs/boost"

src_compile(){
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
