# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Libmemcached wrapper written as a Python extension"
HOMEPAGE="http://lericson.blogg.se/code/category/pylibmc.html"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

RDEPEND=">=dev-libs/libmemcached-0.26
	dev-lang/python"
DEPEND="${RDEPEND}
	dev-python/setuptools"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
