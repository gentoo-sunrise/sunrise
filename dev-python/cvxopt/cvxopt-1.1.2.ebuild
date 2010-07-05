# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND='*'
SUPPORT_PYTHON_ABIS=1
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES=1

inherit distutils

DESCRIPTION="A Python Package for Convex Optimization"
HOMEPAGE="http://abel.ee.ucla.edu/cvxopt"
SRC_URI="http://abel.ee.ucla.edu/src/${P}.tar.gz
	http://abel.ee.ucla.edu/src/python3-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fftw glpk gsl"

DEPEND="virtual/blas
	virtual/lapack
	virtual/cblas
	fftw? ( sci-libs/fftw )
	glpk? ( sci-mathematics/glpk )
	gsl? ( sci-libs/gsl )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/src

src_prepare(){
	distutils_src_prepare

	prepare_builddir() {
		if [[ $(python_get_version --major) -eq 3 ]]; then
			rm -r * || die
			cp -lpr "${WORKDIR}"/python3-${P}/src/* . || die
		fi

		set_flag() {
			if use ${1}; then
				sed -i -e "s/\(BUILD_${2} =\) 0/\1 1/" setup.py || die
			fi
		}

		set_flag gsl GSL
		set_flag fftw FFTW
		set_flag glpk GPLK
	}
	python_execute_function -s prepare_builddir
}
