# Copyright 1999-2010 Gentoo Foundation
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

RDEPEND=">=sys-apps/acl-2.2.32
	dev-cpp/gtkmm:2.4
	>=gnome-base/libgnome-2.10
	>=gnome-base/nautilus-2.12.2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( >=sys-devel/gettext-0.15 )"

pkg_setup() {
	G2CONF="${G2CONF}
	        $(use_enable xattr user-attributes)
	        $(use_enable nls)"
	DOCS="AUTHORS README"
}
