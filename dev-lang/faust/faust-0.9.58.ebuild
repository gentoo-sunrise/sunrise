# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Functional programming language for realtime audio plugins and applications development"
HOMEPAGE="http://faust.grame.fr/"
SRC_URI="mirror://sourceforge/faudiostream/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="app-arch/unzip"

pkg_setup() {
	tc-export CC CXX AR RANLIB
}

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README

	if use doc; then
		dodoc documentation/faust{-quick-reference,-soft-computing,_tutorial}.pdf
	fi

	if use examples; then
		dodoc -r examples
	fi
}

pkg_postinst() {
	elog "Please note that faust is only concerned with creating C++ source "
	elog "code. To actually compile this source code, you must have available "
	elog "libraries for one or more of ALSA, jack, OSS, ladspa or PD"
}
