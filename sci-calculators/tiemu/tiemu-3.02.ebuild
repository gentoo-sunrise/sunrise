# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions

DESCRIPTION="TI89(ti)/92(+)/V200 emulator"
HOMEPAGE="http://lpg.ticalc.org/prj_tiemu/"
SRC_URI="mirror://sourceforge/gtktiemu/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus kde nls"

DEPEND=">=sci-libs/libticables2-1.0.0
		>=sci-libs/libticalcs2-1.0.7
		>=sci-libs/libtifiles2-1.0.7
		>=sci-libs/libticonv-1.0.4
		>=dev-libs/glib-2.6.0
		>=gnome-base/libglade-2.4.0
		>=x11-libs/gtk+-2.6.0
		nls? ( sys-devel/gettext )
		dbus? ( >=dev-libs/dbus-glib-0.60 )"

RDEPEND="${DEPEND}"

src_compile() {
	use kde && set-kdedir 3

	econf \
		$(use_enable nls) \
		$(use_with kde) \
		$(use_enable dbus)

	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README README.linux RELEASE THANKS TODO
}
