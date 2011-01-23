# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN="Pyccuracy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python tool that aims to make it easier to write automated acceptance tests"
HOMEPAGE="https://github.com/heynemann/pyccuracy http://pypi.python.org/pypi/Pyccuracy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
	http://cloud.github.com/downloads/heynemann/${PN}/${MY_P}.tar.gz"

LICENSE="OSL-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/lxml
	dev-python/selenium"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"
