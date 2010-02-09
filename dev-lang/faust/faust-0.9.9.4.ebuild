# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Functional programming language for realtime audio plugins and applications development"
HOMEPAGE="http://faust.grame.fr/"
SRC_URI="mirror://sourceforge/faudiostream/${P}b.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

src_prepare() {
	epatch "${FILESDIR}/${P}_Makefile.patch"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"
	dodoc README || die "Installing README failed"

	if use doc; then
		dodoc documentation/faust{-quick-reference,-soft-computing,_tutorial}.pdf \
			|| die "Installing docs failed"
	fi

	if use examples; then
		docinto examples
		dodoc examples/* || die "Installing examples failed"
	fi
}

pkg_postinst() {
	elog "Please note that faust is only concerned with creating C++ source "
	elog "code. To actually compile this source code, you must have available "
	elog "libraries for one or more of ALSA, jack, OSS, ladspa or PD"
}
