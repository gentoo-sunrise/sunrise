# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="File corruption detection and repair program"
HOMEPAGE="http://sourceforge.net/projects/zidrav/"
SRC_URI="mirror://sourceforge/zidrav/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	sed -i \
		-e "s:g++:$(tc-getCXX):" \
		-e "s:-O2:${CXXFLAGS}:" \
		Makefile || die "sed Makefile failed"
}

src_install() {
	dodoc README TODO Changelog zidrav.txt || die "dodoc failed"
	doman zidrav.1 || die "doman failed"
	dobin zidrav || die "dobin failed"
}
