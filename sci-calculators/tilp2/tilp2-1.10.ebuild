# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit qt3

DESCRIPTION="Program allowing a PC to communicate with a TI calculator."
HOMEPAGE="http://lpg.ticalc.org/prj_tilp"
SRC_URI="mirror://sourceforge/tilp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde xinerama"

RDEPEND=">=sci-libs/libticalcs2-1.1.0
	>=sci-libs/libticables2-1.2.0
	>=sci-libs/libtifiles2-1.1.0
	>=sci-libs/libticonv-1.1.0
	>=x11-libs/gtk+-2.6.0
	>=dev-libs/glib-2.6.0
	>=gnome-base/libglade-2
	kde? ( kde-base/kdelibs:3.5 )
	xinerama? ( x11-libs/libXinerama )"

DEPEND="${RDEPEND}
	xinerama? ( x11-proto/xineramaproto )"

src_compile() {
	econf \
		$(use_with kde) \
		$(use_with xinerama) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
