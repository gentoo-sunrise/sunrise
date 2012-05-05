# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils gnome2

DESCRIPTION="A fully-featured alarm clock for your GNOME panel"
HOMEPAGE="http://alarm-clock.pseudoberries.com/"
SRC_URI="http://launchpad.net/alarm-clock/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	dev-libs/libunique
	gnome-base/gnome-panel
	media-libs/gstreamer
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
	dev-util/intltool
	app-text/gnome-doc-utils
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-libnotify-0.7.patch"
	eautoreconf
	gnome2_src_prepare
}
