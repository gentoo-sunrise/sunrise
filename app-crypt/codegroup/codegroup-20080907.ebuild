# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="encode / decode binary file as five letter codegroups"
HOMEPAGE="http://www.fourmilab.ch/codegroup/"
SRC_URI="http://www.fourmilab.ch/${PN}/${PN}.zip -> ${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	sed -i -e '/^CFLAGS = /d' Makefile || die
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin ${PN} || die

	doman ${PN}.1 ||  die
	dodoc ${PN}.{html,jpg} ||  die
}
