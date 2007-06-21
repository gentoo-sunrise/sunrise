# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Ncurses RSS client"
HOMEPAGE="http://www.codezen.org/nrss/"
SRC_URI="http://ncurses-rss.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/expat
		sys-libs/ncurses"

RDEPEND="net-misc/wget"

src_unpack() {
	unpack ${A}
	cd "${S}"
	AT_M4DIR="m4" eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
