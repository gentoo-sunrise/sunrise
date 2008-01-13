# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WX_GTK_VER=2.6
inherit wxwidgets

DESCRIPTION="query multiple search engines at the same time"
HOMEPAGE="http://olivier.coupelon.free.fr/teardrop/"
SRC_URI="http://olivier.coupelon.free.fr/${PN}/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="unicode"

DEPEND="virtual/libiconv
	dev-libs/libxml2
	net-misc/curl
	dev-libs/libpcre
	=x11-libs/wxGTK-2.6*"
RDEPEND="${DEPEND}"

src_compile() {
	use unicode && need-wxwidgets unicode

	econf --with-wx-config="${WX_CONFIG}"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog
}
