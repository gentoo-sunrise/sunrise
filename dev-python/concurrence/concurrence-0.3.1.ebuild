# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND='2:2.5'
RESTRICT_PYTHON_ABIS='3.*'

inherit distutils

DESCRIPTION="Concurrence is a framework for creating massively concurrent network applications in Python"
HOMEPAGE="http://opensource.hyves.org/concurrence"
SRC_URI="http://concurrence.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc examples"

DEPEND="dev-python/pyrex
	dev-python/setuptools
	dev-libs/libevent"
RDEPEND="dev-libs/libevent"

DISTUTILS_SRC_TEST=setup.py

src_install() {
	distutils_src_install

	if use doc; then
		dodoc doc/* || die
	fi

	if use examples; then
		docinto examples
		dodoc examples/* || die
	fi
}
