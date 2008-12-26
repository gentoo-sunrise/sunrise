# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils

DESCRIPTION="Colorizing wrapper around make"
HOMEPAGE="http://bre.klaki.net/programs/colormake/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="vanilla"
RDEPEND="dev-lang/perl"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	use vanilla || epatch "${FILESDIR}"/${P}-disable-broken-tagging.patch
	mv cmake colormake  # prevent clash with dev-util/cmake
	rm Makefile
}

src_install() {
	dobin colormake{,.pl} || die
}
