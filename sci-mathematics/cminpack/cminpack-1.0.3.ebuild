# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Software for solving nonlinear equations and nonlinear least squares problems"
HOMEPAGE="http://devernay.free.fr/hacks/cminpack.html"
SRC_URI="http://devernay.free.fr/hacks/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die
}

src_install() {
	dolib.a libminpack.a || die
	insinto /usr/include
	doins {,c}minpack.h || die
	dodoc readme{,C}.txt || die
}
