# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="High-level library for HTTP, WebDAV and CalDAV operations"
HOMEPAGE="http://pypi.python.org/pypi/zanshin/"
SRC_URI="mirror://pypi/z/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="doc? ( dev-python/epydoc )"
RDEPEND="dev-python/twisted-web"

src_test() {
	testing() {
		PYTHONPATH="build/lib/" $(PYTHON) setup.py test
	}
	python_execute_function testing
}

src_compile() {
	if use doc; then
		$(PYTHON -f) setup.py doc || die "Creating the docs failed!"
	fi
	distutils_src_compile
}

src_install() {
	if use doc; then
		dohtml -r doc/* || die "Installing the docs failed!"
	fi
	distutils_src_install
}
