# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
	doc?  ( dev-python/epydoc )
	test? (	dev-python/nose
		dev-db/mongodb )"

src_install() {
	distutils_src_install

	if use doc; then
		epydoc --config=epydoc-config || die "epydoc failed"
		dohtml -r html/* || die "Installing docs failed"
	fi
}

src_test() {
	einfo "${PN} tests assume that you have a mongodb running on localhost:27017"
	PYTHONPATH=build/lib ${python} setup.py test || die "Tests failed"
}
