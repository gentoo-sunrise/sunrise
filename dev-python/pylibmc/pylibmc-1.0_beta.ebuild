# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils versionator
SUPPORT_PYTHON_ABIS="1"

MY_P=${PN}-$(replace_version_separator 2 '-')
DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="http://lericson.blogg.se/code/category/pylibmc.html"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libmemcached-0.32"
DEPEND="${RDEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MY_P}

src_test() {
	testing() {
		PYTHONPATH="$(dir -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" tests.py || die "Tests failed"
	}
	python_execute_function testing
}
