# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Google Contacts wrapper for mutt"
HOMEPAGE="http://code.google.com/p/goobook/"
SRC_URI="http://pypi.python.org/packages/source/g/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/gdata"
