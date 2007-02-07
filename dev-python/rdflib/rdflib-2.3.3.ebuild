# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils

DESCRIPTION="Python library for working with RDF"
HOMEPAGE="http://rdflib.net"
SRC_URI="http://rdflib.net/2006/10/15/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	DOCS="example.py"
	distutils_src_install
}

src_test() {
	PYTHONPATH=. "${python}" run_tests.py || die "tests failed"
}
