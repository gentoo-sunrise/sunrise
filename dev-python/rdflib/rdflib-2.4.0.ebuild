# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python library for working with RDF"
HOMEPAGE="http://rdflib.net/"
SRC_URI="http://rdflib.net/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="test"

DEPEND=">=dev-python/setuptools-0.6_rc5
	test? ( >=dev-python/nose-0.9.2 )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't install tests, it's rude
	# remove tests_require to prevent setuptools
	# from trying to download deps that it can't find
	sed -i \
		-e "s/\(find_packages(\)/\1exclude=('test','test.*')/" \
		-e "/tests_require/d" \
		setup.py || die "sed in setup.py failed"
}

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PF}/examples
	doins -r examples/*
}

src_test() {
	# works without setting PYTHONPATH
	${python} setup.py test || die "tests failed"
}
