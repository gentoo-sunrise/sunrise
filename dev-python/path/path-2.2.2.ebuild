# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.5 3:3.1"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4"
PYTHON_TESTS_RESTRICTED_ABIS="3.*"

MY_PN=${PN}.py

inherit distutils

DESCRIPTION="Helpful python wrapper to the os.path module"
HOMEPAGE="http://pypi.python.org/pypi/path.py"
SRC_URI="mirror://pypi/p/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# Don't install test_path.py
	sed -i \
		-e "s/, 'test_path'//" \
		setup.py || die "sed failed"
}

src_test() {
	my_test() {
    	"$(PYTHON)" test_path.py || die
	}
	python_execute_function my_test
}
