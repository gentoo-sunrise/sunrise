# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="An efficient regular expression library written in C++"
HOMEPAGE="http://code.google.com/p/re2/"
SRC_URI="mirror://github/jauhien/sources/${P}.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	tc-export CXX AR NM
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" libdir="/usr/$(get_libdir)" install
}
