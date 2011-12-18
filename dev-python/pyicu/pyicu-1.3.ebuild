# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="*-jython"
DISTUTILS_SRC_TEST=setup.py
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES=1 # setup.py applies 2to3 to tests

inherit base distutils

MY_PN="PyICU"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Python bindings for dev-libs/icu"
HOMEPAGE="http://pyicu.osafoundation.org/"
SRC_URI="mirror://pypi/P/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/icu-4.6"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES CREDITS README"
PATCHES=(
	"${FILESDIR}/r191-tzinfo.patch" # epydoc will fail without this
)

src_prepare() {
	base_src_prepare
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	if use doc; then
		local doc_abi abi
		for abi in ${PYTHON_ABIS}; do
			# Find latest 2.* ABI, fall back to latest ABI if there is no 2.*
			if [[ ${abi} == 2* ]] || [[ ${doc_abi} != 2* ]]; then
				doc_abi=${abi}
			fi
		done
		local epydoc=epydoc-${doc_abi}
		[[ -x ${EROOT}/usr/bin/${epydoc} ]] || epydoc=epydoc
		echo " * Making documentation from ${doc_abi} build using ${epydoc}"
		cd "${S}-${doc_abi}"
		PYTHON_ABI=${doc_abi}
		PYTHONPATH=$(_distutils_get_PYTHONPATH) \
			${epydoc} --html --verbose \
			--url="${HOMEPAGE}" --name="${MY_P}" \
			icu.py || die "Making the docs failed!"
	fi
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -r ../*/html/* || die "Installing the docs failed!"
	fi
}
