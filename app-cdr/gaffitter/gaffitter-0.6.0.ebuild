# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Genetic Algorithm File Fitter"
HOMEPAGE="http://gaffitter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -i  -e "/^INCLUDES\ =.*/d" \
		-e "s/^CXXFLAGS\ =.*/CXXFLAGS\ =\ ${CXXFLAGS}/" \
		-e "s/^CXX\ =.*/CXX\ =\ $(tc-getCXX)/" src/Makefile || die "sed failed"
}

src_install() {
	dobin src/gaffitter || die "dobin failed"
	dodoc AUTHORS README || die "dodoc failed"
}
