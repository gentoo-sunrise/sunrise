# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="FormBuild"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Build forms quickly and easily using groups of simple helper functions"
HOMEPAGE="http://jimmyg.org/work/code/formbuild/index.html"
SRC_URI="http://cheeseshop.python.org/packages/source/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/nose )"
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" LC_ALL="C" nosetests-${PYTHON_ABI}
	}
	python_execute_function testing
}
