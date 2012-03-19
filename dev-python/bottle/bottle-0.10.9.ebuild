# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2:2.5 3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4"
PYTHON_TESTS_RESTRICTED_ABIS="3.*"

inherit distutils

DESCRIPTION="A fast and simple micro-framework for small web-applications"
HOMEPAGE="http://bottle.paws.de/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PYTHON_MODNAME=${PN}.py

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/testall.py || die
	}
	python_execute_function testing
}
