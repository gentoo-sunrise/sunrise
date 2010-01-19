# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P=PottyMouth-${PV}
DESCRIPTION="A python library that scrubs untrusted text to valid, nice-looking, completely safe XHTML"
HOMEPAGE="http://devsuki.com/pottymouth/"
SRC_URI="${HOMEPAGE}/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

RESTRICT_PYTHON_ABIS="3*"
S=${WORKDIR}/${MY_P}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py || die "Tests failed"
	}
	python_execute_function testing

}
