# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Bluetooth helpers for GNOME"
HOMEPAGE="http://www.bluez.org/"
SRC_URI="http://bluez.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="libnotify"
DEPEND=">=dev-libs/glib-2.0
	libnotify? ( >=x11-libs/libnotify-0.3.2 )
	>=gnome-base/gconf-2.6
	>=dev-libs/dbus-glib-0.60
	>=x11-libs/gtk+-2.6"
RDEPEND="=net-wireless/bluez-utils-3*"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README NEWS
}

