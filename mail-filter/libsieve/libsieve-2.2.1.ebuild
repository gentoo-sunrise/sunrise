# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit toolchain-funcs

DESCRIPTION="A library for parsing, sorting and filtering your mail."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libsieve.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	cd ${S}/src
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	cd ${S}/src
	emake DESTDIR="${D}" install || die "emake install failed"
}
