# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Benchmarking for memory and cache"
HOMEPAGE="http://www.alasir.com/software/ramspeed/"
SRC_URI="http://www.alasir.com/software/${PN}/${P}.tar.gz"

LICENSE="Alasir"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare(){
	tc-export CC
	echo "ramspeed: ramspeed.o intmark.o intmem.o fltmark.o fltmem.o" > Makefile
}

src_install(){
	dobin ${PN} || die
	dodoc HISTORY README || die
}
