# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python driver for MongoDB"
HOMEPAGE="http://github.com/mongodb/mongo-python-driver"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="|| ( >=dev-lang/python-2.5
	( =dev-lang/python-2.4* >=dev-python/celementtree-1.0.5 ) )"
DEPEND="${RDEPEND}
	dev-python/setuptools
	doc?  ( dev-python/sphinx )
	test? (	dev-python/nose
		dev-db/mongodb )"

RESTRICT_PYTHON_ABIS="3.*"

src_compile() {
	distutils_src_compile

	if use doc; then
		mkdir html
		sphinx-build doc html || die "building docs failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r html/* || die "Error installing docs"
	fi
}
