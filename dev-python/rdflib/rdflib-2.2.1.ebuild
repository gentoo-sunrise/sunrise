# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python library for working with RDF"
HOMEPAGE="http://rdflib.net"
SRC_URI="http://rdflib.net/2005/08/25/rdflib-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/python"
RDEPEND=""

src_install() {
	mydoc="example.py run_tests.py"

	distutils_src_install
}
