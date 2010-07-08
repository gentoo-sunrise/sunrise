# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
WX_GTK_VER=2.8
inherit wxwidgets

DESCRIPTION="Query multiple search engines at the same time"
HOMEPAGE="http://www.teardrop.fr/"
SRC_URI="http://www.teardrop.fr/releases/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-libs/libpcre
	dev-libs/libxml2
	net-misc/curl
	virtual/libiconv
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog || die
}
