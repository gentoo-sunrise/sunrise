# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils python

DESCRIPTION="A complete Python wrapper for the Google Chart API"
HOMEPAGE="http://pygooglechart.slowchop.com/"
SRC_URI="http://pygooglechart.slowchop.com/files/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools
	test? ( dev-python/PyQrcodec )"
RDEPEND=""

# Tests currently fail
RESTRICT="test"
PYTHON_MODNAME="${PN}.py"

src_test() {
	# The test scripts import the test.test_base module; need this to get python
	# to recognize the test module.
	touch test/__init__.py

	testing() {
		# python_execute_function will die if this function returns a non-zero
		# exit status.
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_general.py && \
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/test_bugs.py
	}
	python_execute_function testing
}
