# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="openopt"

inherit distutils

MY_PN="OpenOpt"

DESCRIPTION="A python module for numerical optimization"
HOMEPAGE="http://openopt.org"
SRC_URI="http://openopt.org/images/3/33/${MY_PN}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-python/numpy"
DEPEND="${RDEPEND}
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="2.4 3.*"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	sed -i -e 's/find_packages()/find_packages(exclude=["openopt.examples", "openopt.tests"])/' setup.py || die
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/${PF}/examples
		doins -r openopt/examples/* || die
	fi
}
