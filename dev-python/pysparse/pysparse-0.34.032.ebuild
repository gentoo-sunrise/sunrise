# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="PySparse adds a set of sparse matrix types holding double precision values to Python"
SRC_URI="mirror://sourceforge/pysparse/${P}.tar.gz"
HOMEPAGE="http://people.web.psi.ch/geus/pyfemax/pysparse.html"

IUSE=""
SLOT="0"
KEYWORDS="~x86"
LICENSE="as-is"

DEPEND=">=dev-lang/python-2.2
	virtual/blas
	virtual/lapack
	>=dev-python/numeric-21.0"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}.patch"
}
