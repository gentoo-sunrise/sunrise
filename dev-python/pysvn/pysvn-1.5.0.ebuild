# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python toolchain-funcs multilib

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="http://pysvn.tigris.org/"
SRC_URI="http://pysvn.tigris.org/files/documents/1233/34994/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=dev-util/subversion-1.2.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/Source"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# no kerberos linkage
	epatch "${FILESDIR}/${P}-nokrb.patch"

	python setup.py configure || die "configure failed"

	# we want our CFLAGS as well and don't need krb linkage
	sed -e 's:^\(CCFLAGS=\)\(.*\):\1$(CFLAGS) \2:g' \
		-e 's:^\(CCCFLAGS=\)\(.*\):\1$(CXXFLAGS) \2:g' \
		-e "/^CCC=/s:g++:$(tc-getCXX):" \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-i Makefile \
		|| die "sed failed in Makefile"
}

src_install() {
	python_version

	cd pysvn
	exeinto /usr/$(get_libdir)/python${PYVER}/site-packages/pysvn
	doexe _pysvn.so
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/pysvn
	doins __init__.py

	cd "${S}/../Docs"
	dohtml *.html *.js
}

pkg_postinst() {
	python_mod_compile "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages"
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages"
}
