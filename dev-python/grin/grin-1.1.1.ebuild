# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A grep program configured the way I like it"
HOMEPAGE="http://pypi.python.org/pypi/grin"
SRC_URI="http://pypi.python.org/packages/source/g/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	DOCS="README.txt THANKS.txt"
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins -r examples || die "doins failed"
}
