# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Hex editor with vi/ex-style user interface"
HOMEPAGE="http://devel.ringlet.net/editors/hexer/"
SRC_URI="http://devel.ringlet.net/editors/${PN}/${P}.tar.gz"

LICENSE="hexer"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-qa.patch
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	dobin ${PN} bin2c
	doman ${PN}.1
	dodoc CHANGES README
}
