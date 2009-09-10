# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="http://undefined.org/python/#greenlet"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/nose )"
RDEPEND="dev-lang/python"

src_prepare() {
	epatch "${FILESDIR}/fix_setuptools.patch"
}

src_test() {
	${python} setup.py test || die "Tests failed"
}
