# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"
PYTHON_DEPEND="2:2.6"

inherit distutils python

DESCRIPTION="Storage protocol for Ubuntu One cloud file hosting"
HOMEPAGE="http://launchpad.net/ubuntuone-storage-protocol"
SRC_URI="http://launchpad.net/${PN}/trunk/lucid-final/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	dev-libs/protobuf[python]
	dev-python/pyopenssl
	dev-python/pyxdg
	dev-python/twisted
	dev-python/oauth"
