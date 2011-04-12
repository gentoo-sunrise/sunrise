# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="2:2.7 3"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_P=${P/_/-}

DESCRIPTION="Fast XML template compiler for Python"
HOMEPAGE="http://chameleon.repoze.org"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="doc? ( dev-python/sphinx )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

RESTRICT_PYTHON_ABIS="2.[456]"

src_compile() {
	distutils_src_compile

	if use doc ; then
		emake html || die "make html failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml -r _build/html/* || die "dohtml failed"
	fi
}
