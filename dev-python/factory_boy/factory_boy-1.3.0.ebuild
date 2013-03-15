# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="A versatile test fixtures replacement"
HOMEPAGE="http://pypi.python.org/pypi/factory_boy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=""
DEPEND="doc? ( dev-python/sphinx )"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		emake -C docs html
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r -A txt docs/_build/html/*
	fi
}
