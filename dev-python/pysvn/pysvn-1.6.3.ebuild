# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python toolchain-funcs

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="http://pysvn.tigris.org/"
SRC_URI="http://pysvn.barrys-emacs.org/source_kits/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples"

DEPEND="dev-util/subversion"
#	>=dev-python/pycxx-5.5.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/Source"

src_unpack() {
	python_version

	unpack ${A}
	cd "${S}"

	# since pysvn-1.6.3: These sources are not compatible with python =< 2.5 - run
	# the backport command to fix
	if [ $PYVER_MAJOR -eq 2 ] && [ $PYVER_MINOR -lt 6 ]; then
		einfo "prepare sources for python prior 2.6"
		python setup.py backport || die "backport failed"
	fi

	# needed to generate the Makefile
	python setup.py configure || die "configure failed"

	# we want our CFLAGS as well
	sed -e 's:^\(CCFLAGS=\)\(.*\):\1$(CFLAGS) \2:g' \
		-e 's:^\(CCCFLAGS=\)\(.*\):\1$(CXXFLAGS) \2:g' \
		-e "/^CCC=/s:g++:$(tc-getCXX):" \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-i Makefile \
		|| die "sed failed in Makefile"
}

src_test() {
	vecho ">>> Test phase [test]: ${CATEGORY}/${PF}"
	emake test || die "test-pysvn.so failed"
	emake -C ../Tests || die "test failed"
	vecho ">>> Test phase [none]: ${CATEGORY}/${PF}"
}

src_install() {
	local sitedir="$(python_get_sitedir)/${PN}"

	cd pysvn/

	exeinto ${sitedir}
	doexe _pysvn*.so || die "doexe failed"
	insinto ${sitedir}
	doins __init__.py || die "doins failed"

	cd ../

	if use doc; then
		dohtml -r ../Docs/ || die "dohtml failed"
	fi

	if use examples; then
		docinto examples
		dodoc ../Examples/Client/* || die "dodoc examples failed"
	fi
}

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "$(python_get_sitedir)/${PN}"
}
