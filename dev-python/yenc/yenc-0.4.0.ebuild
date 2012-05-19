# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.*"

inherit distutils python

DESCRIPTION="A fairly simple module, it provide only raw yEnc encoding/decoding"
HOMEPAGE="http://www.golug.it/yenc.html"
SRC_URI="http://www.golug.it/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	distutils_src_install

	dodoc doc/yenc-draft.1.3.txt
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" \
			"$(PYTHON)" "test/test.py"
	}
	python_execute_function testing
}