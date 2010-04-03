# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A networking library that achieves high scalability by using non-blocking io"
HOMEPAGE="http://wiki.secondlife.com/wiki/Eventlet"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="dev-python/greenlet
	<dev-lang/python-2.6? ( dev-python/pyopenssl )"

DEPEND="${RDEPEND}
	dev-python/setuptools
	doc? ( dev-python/sphinx )
	test? (
		|| ( dev-lang/python[sqlite] dev-python/pysqlite )
		dev-python/nose )"

RESTRICT_PYTHON_ABIS="3.*"

DOCS="README README.twisted NEWS"

src_compile() {
	distutils_src_compile

	if use doc; then
		mkdir html
		PYTHONPATH=. sphinx-build doc html || die "Building docs failed"
	fi
}

src_test() {
	testing() {
		PYTHONPATH="." nosetests-${PYTHON_ABI} || die "Tests failed"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use examples ; then
		dodoc examples/* || die "Install failed"
	fi

	if use doc; then
		dohtml -r html/* || die "Error installing docs"
	fi
}
