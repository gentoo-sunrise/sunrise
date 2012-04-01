# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils

MY_PN=Spawning
MY_P=${MY_PN}-${PV}
DESCRIPTION="A flexible web server written in Python"
HOMEPAGE="http://pypi.python.org/pypi/Spawning"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/eventlet
	dev-python/pastedeploy
	|| ( >=dev-lang/python-2.6
		( dev-lang/python:2.5 dev-python/simplejson ) )"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install

	doinitd rc-scripts/init.d/spawning || die "Install failed"
	doconfd rc-scripts/conf.d/spawning || die "Install failed"
}
