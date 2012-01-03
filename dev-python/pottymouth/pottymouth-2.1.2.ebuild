# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

MY_P=PottyMouth-${PV}
DESCRIPTION="A python library that scrubs untrusted text to valid, nice-looking, completely safe XHTML"
HOMEPAGE="http://glyphobet.net/pottymouth/"
SRC_URI="${HOMEPAGE}dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MY_P}

DOCS="readme.html"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-setup.patch" || die
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py || die "Tests failed"
	}
	python_execute_function testing

}
