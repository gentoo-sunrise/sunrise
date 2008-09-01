# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="Python library for symbolic mathematics."
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gtk latex mathml pdf png test texmacs"

RDEPEND="mathml? (
		dev-libs/libxml2
		dev-libs/libxslt
		gtk? ( x11-libs/gtkmathview )
	)
	latex? (
		virtual/latex-base
		png? ( app-text/dvipng )
		pdf? ( virtual/ghostscript )
	)
	texmacs? ( app-office/texmacs )
	dev-python/pyopengl
	dev-python/imaging
	|| ( dev-python/ctypes >=dev-lang/python-2.5 )
	>=dev-python/pexpect-2.0"
DEPEND="test? ( >=dev-python/py-0.9.0 )
	${RDEPEND}"

pkg_setup() {
	if use mathml ; then
		if ! built_with_use "dev-libs/libxml2" python ; then
			eerror "dev-libs/libxml2 has to be compiled with 'python' USE-flag."
			die "Needed USE-flag for dev-libs/libxml2 not found."
		fi

		if ! built_with_use "dev-libs/libxslt" python ; then
			eerror "dev-libs/libxslt has to be compiled with 'python' USE-flag."
			die "Needed USE-flag for dev-libs/libxslt not found."
		fi

		if use gtk && ! built_with_use "x11-libs/gtkmathview" gtk ; then
			eerror "x11-libs/gtkmathview has to be compiled with 'gtk' USE-flag."
			die "Needed USE-flag for x11-libs/gtkmathview not found."
		fi
	fi
}

src_test() {
	PYTHONPATH=build/lib/ "${python}" setup.py test || die "Unit tests failed!"
}

src_install() {
	distutils_src_install

	if use examples ; then
		insinto /usr/share/doc/${P}
	    doins -r examples
	fi

	if use texmacs ; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}

pkg_postinst() {
	if ! has_version ">=dev-python/ipython-0.7.2" ; then
		elog
		elog "IPython 0.7.2 (or better) wasn't found on your system. It is"
		elog "highly recommended to install this package to optimize your"
		elog "work with SymPy. To do so, you can run:"
		elog
		elog " emerge '>=dev-python/ipython-0.7.2'"
		elog
	fi
}

pkg_postrm() {
	if use examples ; then
		python_mod_cleanup /usr/share/doc/${P}
	fi
}
