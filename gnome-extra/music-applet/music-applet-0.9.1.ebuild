# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GNOME applet to control various music players"
HOMEPAGE="http://web.ics.purdue.edu/~kuliniew/music-applet"
SRC_URI="http://web.ics.purdue.edu/~kuliniew/${PN}/downloads/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dbus"

RDEPEND=">=x11-libs/gtk+-2.6
	>=gnome-base/libgnomeui-2
	>=gnome-base/gnome-panel-2
	dbus? ( sys-apps/dbus )"

DEPEND="${RDEPEND} dev-util/pkgconfig"

G2CONF="$(use_with dbus) --without-xmms2"

pkg_postinst() {
	gnome2_pkg_postinst

	if ! use dbus; then
		ewarn "You have disabled dbus support, Rhythmbox 0.9.x"
		ewarn "and banshee support work only with dbus, then if"
		ewarn "you want to use these players, recompile this"
		ewarn "package with flag use dbus enabled."
	fi
}
