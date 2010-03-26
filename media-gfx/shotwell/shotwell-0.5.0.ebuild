# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit fdo-mime gnome2-utils versionator

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Open source photo manager for GNOME"
HOMEPAGE="http://www.yorba.org/shotwell/"
SRC_URI="http://www.yorba.org/download/${PN}/${MY_PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/dbus-glib-0.80
	gnome-base/gconf
	>=dev-libs/libgee-0.5.0
	>=x11-libs/gtk+-2.14.4:2
	media-libs/libexif
	media-libs/libgphoto2
	>=net-libs/libsoup-2.26.0
	dev-libs/libxml2
	dev-db/sqlite:3
	dev-libs/libunique
	>=dev-lang/vala-0.7.10
	>=net-libs/webkit-gtk-1.1.5"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" \
		DISABLE_DESKTOP_UPDATE="1" DISABLE_SCHEMAS_INSTALL="1" \
		DISABLE_ICON_UPDATE="1" \
		install || die "emake install failed"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
