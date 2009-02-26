# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="High-level library for HTTP, WebDAV and CalDAV operations"
HOMEPAGE="http://chandlerproject.org/Projects/ZanshinProject"
SRC_URI="http://pypi.python.org/packages/source/z/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="doc? ( dev-python/epydoc )"
RDEPEND="dev-python/twisted-web"

src_test() {
	PYTHONPATH="build/lib/" "${python}" setup.py test \
		|| die "Completing the tests failed!"
}

src_compile() {
	if use doc; then
		${python} setup.py doc || die "Creating the docs failed!"
	fi
	distutils_src_compile
}

src_install() {
	if use doc; then
		dohtml -r doc/* || die "Installing the docs failed!"
	fi
	distutils_src_install
}
