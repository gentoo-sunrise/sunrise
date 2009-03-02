# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="EggTranslations"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides an API for accessing localizations and resources packaged in python eggs"
HOMEPAGE="http://chandlerproject.org/Projects/EggTranslations"
SRC_URI="http://pypi.python.org/packages/source/E/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="doc? ( dev-python/epydoc )"
RDEPEND="dev-python/configobj"

S="${WORKDIR}/${MY_P}"

DOCS="README.txt"

src_compile() {
	if use doc; then
		epydoc --html --verbose --url="${HOMEPAGE}" --name="${MY_P}" egg_translations.py \
			|| die "Making the docs failed!"
	fi
	distutils_src_compile
}

src_test() {
	PYTHONPATH="build/lib/" "${python}" setup.py test || die "Completing the tests failed!"
}

src_install() {
	if use doc; then
		dohtml html/* || die "Installing the docs failed!"
	fi
	distutils_src_install
}
