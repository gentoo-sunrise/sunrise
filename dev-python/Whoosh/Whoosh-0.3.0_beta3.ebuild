# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P=${PN}-${PV/_beta/b}

DESCRIPTION="Fast, pure-Python full text indexing, search, and spell checking library"
HOMEPAGE="http://whoosh.ca"
SRC_URI="http://pypi.python.org/packages/source/W/${PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}
