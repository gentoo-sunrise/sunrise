# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Advanced log tailer written in python"
HOMEPAGE="http://code.google.com/p/log4tailer/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/mox
		dev-python/paramiko )"
RDEPEND=""

src_test() {
	testing() {
		PYTHONPATH=. $(PYTHON) setup.py test
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	insinto /etc
	newins log4tailerconfig.txt log4tailer.conf || die "newins failed"
}
