# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit distutils

DESCRIPTION="Parse human-readable date/time expressions"
HOMEPAGE="http://code-bear.com/code/parsedatetime/"
SRC_URI="http://code-bear.com/code/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="doc? ( dev-python/epydoc )"
RDEPEND="dev-python/pyicu"

DOCS="THANKS.txt README.txt AUTHORS.txt CHANGES.txt"

src_prepare() {
	# A broken and unnecessary test script made it into the release. delete it.
	if [[ -f "${S}/${PN}/t2.py" ]]; then
		rm -f "${S}/${PN}/t2.py" || die "Removing t2.py failed!"
	fi
}

src_compile() {
	if use doc; then
		${python} setup.py doc || die "Making the docs failed"
	fi
	distutils_src_compile
}

src_test() {
	PYTHON_PATH="build/lib/" ${python} run_tests.py || die "Running tests failed!"
}

src_install() {
	if use doc; then
		dohtml -r docs/* || die "Installing the docs failed!"
	fi
	distutils_src_install
}
