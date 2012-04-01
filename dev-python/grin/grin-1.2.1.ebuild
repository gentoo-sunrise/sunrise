# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND='2:2.6'
RESTRICT_PYTHON_ABIS='2.5 3.*'

inherit distutils

DESCRIPTION="A grep program configured the way I like it"
HOMEPAGE="http://pypi.python.org/pypi/grin"
SRC_URI="mirror://pypi/g/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	local DOCS="README.txt THANKS.txt"
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins -r examples || die "doins failed"
}
