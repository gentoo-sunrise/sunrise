# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="http://undefined.org/python/#greenlet"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/nose )"
RDEPEND=""

src_test() {
	testing() {
		PYTHONPATH=".:$(dir -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" setup.py test || die "Tests failed"
	}
	python_execute_function testing
}

src_install() {
	dodoc doc/greenlet.txt || die
}
