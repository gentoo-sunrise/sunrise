# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python im-/export filters for MS Excel files. Including xls2txt, xls2csv and xls2html commands."
HOMEPAGE="http://sourceforge.net/projects/pyexcelerator"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="app-arch/bzip2"
RDEPEND=""

src_install() {
	distutils_src_install

	dobin tools/xls2csv.py || die
	dobin tools/xls2html.py || die
	dobin tools/xls2txt.py || die

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die
	fi
}
