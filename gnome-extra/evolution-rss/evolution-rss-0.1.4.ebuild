# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils gnome2

DESCRIPTION="An RSS reader plugin for Evolution"
HOMEPAGE="http://gnome.eu.org/index.php/Evolution_RSS_Reader_Plugin"
SRC_URI="http://gnome.eu.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus webkit"

RDEPEND=">=mail-client/evolution-2.24
	>=gnome-base/gconf-2
	net-libs/libsoup:2.4
	dev-libs/glib:2
	gnome-base/libglade
	gnome-extra/gtkhtml:3.14
	x11-libs/gtk+:2
	gnome-base/libgnome
	gnome-base/libgnomeui
	>=gnome-extra/evolution-data-server-1.2
	|| ( net-libs/xulrunner:1.9 www-client/seamonkey
		www-client/mozilla-firefox )
	dbus? ( dev-libs/dbus-glib )
	webkit? ( net-libs/webkit-gtk )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog FAQ NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable dbus) $(use_enable webkit)"
}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}"/${PV}-configure.patch
	eautoreconf
}
