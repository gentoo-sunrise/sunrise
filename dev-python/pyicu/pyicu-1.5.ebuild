# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
DISTUTILS_IN_SOURCE_BUILD=1 # setup.py applies 2to3 to tests

inherit distutils-r1

MY_PN="PyICU"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Python bindings for dev-libs/icu"
HOMEPAGE="http://pyicu.osafoundation.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/icu"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )"

PATCHES=(
	"${FILESDIR}/${P}-testPre27.patch"
)

S="${WORKDIR}/${MY_P}"

DOCS=(CHANGES CREDITS README)

python_compile_all() {
	if use doc; then
		einfo "Making documentation from ${EPYTHON} build"
		cd "${BEST_BUILD_DIR}" || die
		epydoc --html --verbose \
			--url="${HOMEPAGE}" --name="${MY_P}" \
			icu.py || die "Making the docs failed!"
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		dohtml -r ../*/html/*
	fi
}
