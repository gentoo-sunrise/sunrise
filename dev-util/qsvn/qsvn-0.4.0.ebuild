# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

DESCRIPTION="GUI frontend to the Subversion revision system"
HOMEPAGE="http://ar.oszine.de/projects/qsvn"
SRC_URI="http://download.berlios.de/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="$(qt4_min_version 4)
	dev-util/subversion
	dev-libs/apr"
RDEPEND="${DEPEND}"

src_compile() {
	qmake || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	dobin bin/qsvn
	dodoc README
}
