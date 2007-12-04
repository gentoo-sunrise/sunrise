# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit qt4

DESCRIPTION="GUI frontend to the Subversion revision system"
HOMEPAGE="http://ar.oszine.de/projects/qsvn/"
SRC_URI="http://download.berlios.de/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/qt-4.0:4
	dev-util/subversion"
RDEPEND="${DEPEND}"

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	dobin bin/qsvn
	dodoc README
}
