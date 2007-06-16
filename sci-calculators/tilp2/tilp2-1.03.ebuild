# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Program allowing a PC to communicate with a TI calculator."
HOMEPAGE="http://lpg.ticalc.org/prj_tilp"
SRC_URI="http://www.wh9.tu-dresden.de/~henning/gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=sci-libs/libticalcs2-1.0.4
	>=sci-libs/libticables2-1.0.2
	>=sci-libs/libtifiles2-1.0.3
	>=sci-libs/libticonv-1.0.0
	>=x11-libs/gtk+-2.0.0
	>=dev-libs/glib-2.6.0
	>=gnome-base/libglade-2"

RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
