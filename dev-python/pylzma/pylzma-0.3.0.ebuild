# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python bindings for the LZMA compression library."
HOMEPAGE="http://www.joachim-bauch.de/projects/python/pylzma/"
SRC_URI="http://www.joachim-bauch.de/projects/python/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

DOCS="doc/usage.txt readme.txt"

src_test() {
	einfo "Testing 7zfiles"
	${python} tests/test_7zfiles.py || die "7zfiles test failed"
	einfo "Testing compatibility"
	${python} tests/test_compatibility.py || die "Compatibility test failed"
	einfo "Testing pylzma"
	${python} tests/test_pylzma.py || die "pylzma test failed"
	einfo "Testing usage"
	${python} tests/test_usage.py || die "usage test failed"
}
