# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="PottyMouth"
MY_P=${MY_PN}-${PV}
DESCRIPTION="A python library that scrubs untrusted text to valid, nice-looking, completely safe XHTML"
HOMEPAGE="http://devsuki.com/pottymouth/"
SRC_URI="http://devsuki.com/${PN}/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="dev-lang/python"

S=${WORKDIR}/${MY_P}

src_test() {
	distutils_python_version
	${python} setup.py test || die "Tests failed"
}
