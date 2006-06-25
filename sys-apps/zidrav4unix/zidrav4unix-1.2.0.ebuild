# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="File corruption detection and repair program"
HOMEPAGE="http://sourceforge.net/projects/zidrav/"
SRC_URI="mirror://sourceforge/zidrav/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:-O2:$(E_CXXFLAGS):' Makefile || die "sed Makefile failed"
}

src_compile() {
	emake E_CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	dodoc README TODO Changelog zidrav.txt
	doman zidrav.1
	dobin zidrav
}