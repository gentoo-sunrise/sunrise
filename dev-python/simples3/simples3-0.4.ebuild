# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5

inherit distutils

DESCRIPTION="A fairly simple, decently quick python interface to Amazon's S3 storage service"
HOMEPAGE="http://lericson.se/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

DEPEND="dev-python/setuptools"
RDEPEND=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS="README TODO"
