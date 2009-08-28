# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils gnome2 versionator

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="A fully-featured alarm clock for your GNOME panel"
HOMEPAGE="http://alarm-clock.pseudoberries.com/"
SRC_URI="http://launchpad.net/alarm-clock/trunk/${MY_PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	gnome-base/gnome-panel
	gnome-base/gnome-vfs:2
	gnome-base/gconf:2
	gnome-base/libgnome
	gnome-base/libgnomeui
	x11-themes/gnome-icon-theme
	gnome-base/libglade:2.0
	media-libs/gstreamer:0.10
	libnotify? ( x11-libs/libnotify )
"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12
	>=app-text/gnome-doc-utils-0.3.2
	dev-util/intltool
"

src_prepare() {
	epatch "${FILESDIR}/${PV}-configure.ac.patch"
	eautoreconf
}

pkg_setup() {
	G2CONF="$(use_enable libnotify)"
}
