# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Python bindings for tokyo tyrant"
HOMEPAGE="http://code.google.com/p/pytyrant/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT_PYTHON_ABIS="3*"

DOCS="README"

src_prepare() {
	epatch "${FILESDIR}/return_test_status.patch"
}

src_test() {
	einfo "${PN} tests require a running instance of tokyo tyrant at port 1978"
	testing() {
		"$(PYTHON)" ${PN}.py || die "Tests failed"
	}
	python_execute_function testing
}
