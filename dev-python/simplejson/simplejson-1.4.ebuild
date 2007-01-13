# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python implementation of a JSON reader/writer"
HOMEPAGE="http://undefined.org/python/#simplejson"
SRC_URI="http://cheeseshop.python.org/packages/source/s/simplejson/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3
	dev-python/setuptools"
