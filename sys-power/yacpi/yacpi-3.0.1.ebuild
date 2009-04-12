# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Yet Another Configuration and Power Interface"
HOMEPAGE="http://www.ngolde.de/yacpi.html"
SRC_URI="http://www.ngolde.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/libacpi
	sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
}

src_compile() {
	emake \
		CC=$(tc-getCC) || \
		die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || \
		die "installation failed"
}
