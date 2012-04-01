# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Python wrapper of OpenBSD's Blowfish password hashing code"
HOMEPAGE="http://www.mindrot.org/projects/py-bcrypt/"
SRC_URI="http://py-bcrypt.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
