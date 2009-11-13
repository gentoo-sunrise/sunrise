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
	distutils_src_install

	dodoc README.txt THANKS.txt || die "dodoc failed"

	insinto /usr/share/doc/${PF}
	doins -r examples || die "doins failed"
}

pkg_postrm() {
	python_mod_cleanup
}
