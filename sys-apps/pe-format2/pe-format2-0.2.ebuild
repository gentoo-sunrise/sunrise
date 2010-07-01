# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Intelligent PE executable wrapper for binfmt_misc"
HOMEPAGE="http://qwpx.net/~mgorny/pe-format2/"
SRC_URI="http://qwpx.net/~mgorny/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin pe-exec || die
	dosbin pe-format2-conf.sh || die
	newconfd pe-format2.conf ${PN} || die
	newinitd pe-format2.init ${PN} || die
}
