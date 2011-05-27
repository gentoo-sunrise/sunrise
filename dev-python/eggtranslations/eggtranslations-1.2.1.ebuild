# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND='2'
RESTRICT_PYTHON_ABIS='3.*'

inherit distutils

MY_PN="EggTranslations"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides an API for accessing localizations and resources packaged in python eggs"
HOMEPAGE="http://chandlerproject.org/Projects/EggTranslations"
SRC_URI="mirror://pypi/E/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( dev-python/epydoc )"
RDEPEND="dev-python/configobj"

S="${WORKDIR}/${MY_P}"

DOCS="README.txt"

DISTUTILS_SRC_TEST=setup.py

src_compile() {
	if use doc; then
		epydoc --html --verbose --url="${HOMEPAGE}" --name="${MY_P}" egg_translations.py \
			|| die "Making the docs failed!"
	fi
	distutils_src_compile
}

src_install() {
	if use doc; then
		dohtml html/* || die "Installing the docs failed!"
	fi
	distutils_src_install
}
