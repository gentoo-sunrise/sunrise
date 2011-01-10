# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P=PyRSS2Gen-${PV}

DESCRIPTION="RSS feed generator written in Python"
HOMEPAGE="http://www.dalkescientific.com/Python/PyRSS2Gen.html"
SRC_URI="http://www.dalkescientific.com/Python/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/${PF}/examples
		doins example.py || die
	fi
}
