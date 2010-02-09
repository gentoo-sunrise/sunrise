# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils gnome2

DESCRIPTION="A versatile and extensible compositing manager which uses cairo for rendering"
HOMEPAGE="http://cairo-compmgr.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/ccm/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/cairo
	x11-libs/pixman"
DEPEND="${RDEPEND}
	>=x11-proto/glproto-1.4.9"

G2CONF="--disable-glitz --disable-glitz-tfp --enable-shave"

src_prepare() {
	epatch "${FILESDIR}/${P}-glitz-tfp-undef.patch"
	epatch "${FILESDIR}/${P}-glitz-code.patch"
	AT_M4DIR="." eautoreconf
}
