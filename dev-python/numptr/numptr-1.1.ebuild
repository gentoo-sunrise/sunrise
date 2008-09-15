# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P=NumPtr-${PV}

SRC_URI="http://geosci.uchicago.edu/csc/numptr/${MY_P}.tar.gz"
DESCRIPTION="SWIGable module to access data stored in Numeric arrays as if they were normal C/C++ arrays"
HOMEPAGE="http://geosci.uchicago.edu/csc/numptr/"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND="dev-lang/swig"
RDEPEND=""

S="${WORKDIR}/${MY_P}"
