# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Tools for generating recursive-descent parsers"
HOMEPAGE="http://piumarta.com/software/peg/"
SRC_URI="http://piumarta.com/software/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${D}/usr" install
}
