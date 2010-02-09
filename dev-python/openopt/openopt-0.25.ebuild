# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"
PYTHON_MODNAME="openopt"

inherit distutils

MY_PN="OpenOpt"
MY_P=${MY_PN}${PV}

DESCRIPTION="A python module for numerical optimization"
HOMEPAGE="http://openopt.org"
SRC_URI="ftp://ftp.linux.kiev.ua/pub/projects/${PN}/download/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-python/numpy"

S=${WORKDIR}/${MY_PN}/
