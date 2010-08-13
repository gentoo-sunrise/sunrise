# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND=2
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS='3.*'

inherit distutils

DESCRIPTION="Helpful python wrapper to the os.path module"
HOMEPAGE="http://pypi.python.org/pypi/path.py"
SRC_URI="mirror://pypi/p/${PN}.py/${P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

my_test() {
	"$(PYTHON)" test_path.py
}

src_prepare() {
	# Don't install test_path.py
	sed -i \
		-e "s/, 'test_path'//" \
		setup.py || die "sed failed"
}

src_test() {
	python_execute_function my_test
}
