# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="http://pysvn.tigris.org/"
SRC_URI="http://pysvn.tigris.org/files/documents/1233/34994/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND=">=dev-util/subversion-1.2.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/Source"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# no kerberos linkage
	epatch "${FILESDIR}/${P}-nokrb.patch"

	python setup.py configure

	# we want our CFLAGS as well and don't need krb linkage
	sed -e 's:^\(CCFLAGS=\)\(.*\):\1$(CFLAGS) \2:g' \
		-e 's:^\(CCCFLAGS=\)\(.*\):\1$(CXXFLAGS) \2:g' \
		-i ${S}/Source/Makefile
}

src_install() {
	python_version

	cd pysvn
	exeinto /usr/lib/python${PYVER}/site-packages/pysvn
	doexe _pysvn.so
	insinto /usr/lib/python${PYVER}/site-packages/pysvn
	doins __init__.py

	if use doc ; then
		cd "${S}/../Docs"
		dohtml *.html *.js
	fi

}

pkg_postinst() {
	python_mod_compile ${ROOT}usr/lib/python${PYVER}/site-packages
}

pkg_postrm() {
	python_mod_cleanup
}
