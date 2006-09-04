# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

KEYWORDS="~x86"

DESCRIPTION="buzhug is a fast, pure-Python database engine, using a syntax that Python programmers should find very intuitive"
HOMEPAGE="http://buzhug.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=app-arch/unzip-5"
RDEPEND=""

src_install() {
	distutils_src_install
	cd "${S}/buzhug/doc"
	dodoc README.txt
	dohtml *.html *.css
}
