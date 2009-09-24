# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Alternative Python bindings for Subversion"
HOMEPAGE="http://samba.org/~jelmer/subvertpy"
SRC_URI="http://samba.org/~jelmer/${PN}/${P}.tar.gz"

IUSE="examples test"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-util/subversion-1.4
	dev-lang/python"
DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( dev-python/nose )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if ! use test ; then
		epatch "${FILESDIR}/remove_tests.patch"
	fi
}

src_test() {
	cd build/lib.*/${PN}/tests || die "Tests failed"
	nosetests || die "Tests failed"
}

src_install() {
	distutils_src_install
	insinto "/usr/share/doc/${PF}"
	if use examples; then
		doins -r examples || die "Install Failed"
	fi
}
