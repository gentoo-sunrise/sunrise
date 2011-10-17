# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P=${PN/-/.}-${PV}
DESCRIPTION="Client for the lazr.restful web services"
HOMEPAGE="https://launchpad.net/lazr.restfulclient"
SRC_URI="http://launchpad.net/${PN/-/.}/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/lazr-uri
	dev-python/httplib2
	dev-python/oauth
	dev-python/simplejson
	dev-python/wadllib
	net-zope/zope-interface"

S=${WORKDIR}/${MY_P}
RESTRICT_PYTHON_ABIS="2.[45] 3.*"

PYTHON_MODNAME="lazr/restfulclient"
