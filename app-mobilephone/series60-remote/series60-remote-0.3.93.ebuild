# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A Python application to manage your S60 3rd Edition mobile phone"
HOMEPAGE="http://series60-remote.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="stats obex"

RDEPEND="obex? ( app-mobilephone/obexftp[python] )
	stats? ( dev-python/matplotlib )
	dev-python/pybluez
	dev-python/PyQt4[sql]"

RESTRICT_PYTHON_ABIS="3.*"

DOCS="TODO Changelog"
