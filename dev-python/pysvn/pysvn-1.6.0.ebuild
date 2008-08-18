# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python toolchain-funcs multilib

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="http://pysvn.tigris.org/"
SRC_URI="http://pysvn.barrys-emacs.org/source_kits/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

DEPEND=">=dev-util/subversion-1.2.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/Source"

src_unpack() {
	unpack ${A}
	cd "${S}"

	python setup.py configure || die "configure failed"

	# we want our CFLAGS as well
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
	exeinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
	doexe _pysvn*.so
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
	doins __init__.py

	cd "${S}/../Docs"
	dohtml *.html *.js

	if use examples; then
		insinto "/usr/share/doc/${PF}/Examples"
		doins -r "${S}"/../Examples/*
	fi
}

pkg_postinst() {
	python_mod_optimize "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}
