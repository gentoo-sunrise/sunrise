# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Another set of autoconf macros for compiling against boost"
HOMEPAGE="http://github.com/tsuna/boost.m4"
SRC_URI="${HOMEPAGE}/zipball/v${PV} -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	default

	mv * ${P} || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-multilib.patch
}

# boost.m4 has a buildsystem which doesn't build nor install
# anything. It only would add a buildtime dependency that boost be
# installed. Thus, noop it:
src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/aclocal
	doins build-aux/boost.m4 || die

	dodoc AUTHORS NEWS README THANKS || die
}
