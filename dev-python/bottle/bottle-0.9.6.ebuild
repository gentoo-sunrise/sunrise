# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="*:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4"

inherit distutils

DESCRIPTION="A fast and simple micro-framework for small web-applications"
HOMEPAGE="http://bottle.paws.de/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PYTHON_MODNAME=${PN}.py

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

src_prepare() {
	distutils_src_prepare

	2to3_conversion() {
		[[ "${PYTHON_ABI}" == 2.* ]] && return
		2to3-${PYTHON_ABI} -nw --no-diffs bottle.py
	}
	python_execute_function -s 2to3_conversion
}
