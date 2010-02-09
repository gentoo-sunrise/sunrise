# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A mock object framework for Python"
HOMEPAGE="http://code.google.com/p/pymox/"
SRC_URI="http://${PN}.googlecode.com/files/${P/py}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/python"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/py}

src_test() {
	PYTHONPATH=. "${python}" mox_test.py || die "tests failed"
}
