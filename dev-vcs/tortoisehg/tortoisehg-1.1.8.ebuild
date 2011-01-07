# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.6"
RESTRICT_PYTHON_ABIS="2.[45] 3.*"

inherit distutils

DESCRIPTION="Mercurial GUI command line tool hgtk"
HOMEPAGE="http://tortoisehg.bitbucket.org"
SRC_URI="http://bitbucket.org/${PN}/targz/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc nautilus"

DEPEND="doc? ( >=dev-python/sphinx-1.0.3 )"
RDEPEND="dev-python/pygtk
	>=dev-vcs/mercurial-1.6.3
	>=dev-python/iniparse-0.4
	nautilus? ( dev-python/nautilus-python )"

src_compile() {
	distutils_src_compile

	if use doc ; then
		emake -C doc html || die
	fi
}

src_install() {
	# make the install respect multilib.
	sed -i -e "s:lib/nautilus/extensions-2.0/python:$(get_libdir)/nautilus/extensions-2.0/python:" setup.py || die

	distutils_src_install
	dodoc doc/ReadMe*.txt doc/TODO || die

	if use doc ; then
		dohtml -r doc/build/html || die
	fi

	if ! use nautilus; then
		einfo "Excluding Nautilus extension."
		rm -fR "${D}"/usr/$(get_libdir)/nautilus || die
	fi
}