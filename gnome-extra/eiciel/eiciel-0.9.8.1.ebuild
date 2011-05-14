# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="no"

inherit gnome2

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="http://rofi.roger-ferrer.org/eiciel/"
SRC_URI="http://rofi.roger-ferrer.org/eiciel/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls xattr"

# revisit gtkmm, libgnome, nautilus rdepends after nautilus-3 is in portage
RDEPEND=">=sys-apps/acl-2.2.32
	dev-cpp/gtkmm:2.4
	>=gnome-base/libgnome-2.10
	=gnome-base/nautilus-2*
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( >=sys-devel/gettext-0.15 )"

pkg_setup() {
	G2CONF="${G2CONF} --disable-static
	        $(use_enable xattr user-attributes)
	        $(use_enable nls)
	        --with-gnome-version=2" # revisit after nautilus-3 is in portage
	DOCS="AUTHORS README"
	# nautilus plugins don't need .la files
	GNOME2_LA_PUNT="yes"
}
