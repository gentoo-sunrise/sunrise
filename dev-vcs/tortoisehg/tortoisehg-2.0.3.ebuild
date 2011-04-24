# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils multilib

DESCRIPTION="Set of graphical tools for Mercurial"
HOMEPAGE="http://tortoisehg.bitbucket.org"
SRC_URI="http://bitbucket.org/${PN}/targz/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc nautilus"

RDEPEND="dev-python/iniparse
	dev-python/pygments
	dev-python/PyQt4
	dev-python/qscintilla-python
	>=dev-vcs/mercurial-1.8
	nautilus? ( dev-python/nautilus-python )"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-1.0.3 )"

src_prepare() {
	# make the install respect multilib.
	sed -i -e "s:lib/nautilus:$(get_libdir)/nautilus:" setup.py || die
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile

	if use doc ; then
		emake -C doc html || die
	fi
}

src_install() {
	distutils_src_install
	dodoc doc/ReadMe*.txt doc/TODO || die

	if use doc ; then
		dohtml -r doc/build/html || die
	fi

	if ! use nautilus; then
		rm -vr "${D}usr/$(get_libdir)/nautilus" || die
	fi
}
