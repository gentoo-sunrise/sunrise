# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="A library for converting a token stream into a data structure for use in web form posts"
HOMEPAGE="http://docs.repoze.org/peppercorn"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
