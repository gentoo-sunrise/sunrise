# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Converts .desktop and .kdelnk files to Windowmaker menu format"
HOMEPAGE="http://ytm.bossstation.dnsalias.org/html/kdelnk.html"
SRC_URI="http://ytm.bossstation.dnsalias.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-Makefile-fixes.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin ${PN} || die
	dodoc AUTHORS BUGS README TODO || die
}
