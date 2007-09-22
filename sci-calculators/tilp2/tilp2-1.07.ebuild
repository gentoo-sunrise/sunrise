# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3

DESCRIPTION="Program allowing a PC to communicate with a TI calculator."
HOMEPAGE="http://lpg.ticalc.org/prj_tilp"
SRC_URI="mirror://sourceforge/tilp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="kde xinerama"

DEPEND=">=sci-libs/libticalcs2-1.0.7
	>=sci-libs/libticables2-1.0.8
	>=sci-libs/libtifiles2-1.0.7
	>=sci-libs/libticonv-1.0.4
	>=x11-libs/gtk+-2.6.0
	>=dev-libs/glib-2.6.0
	>=gnome-base/libglade-2
	kde? ( kde-base/kdelibs )
	xinerama? ( x11-proto/xineramaproto )"

RDEPEND="${DEPEND}
	xinerama? ( x11-libs/libXinerama )"

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
