# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://live.gnome.org/Cheese"

# mirror this manually due to retarded SRC_URI
# SRC_URI="http://live.gnome.org/Cheese/Releases?action=AttachFile&do=get&target=${P}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~jakub/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.12
	dev-libs/dbus-glib
	dev-python/pygobject
	>=gnome-base/gnome-vfs-2.0
	>=gnome-base/libglade-2.0.0
	>=media-libs/gst-plugins-base-0.10.12
	>=x11-libs/gtk+-2.10.0
	x11-libs/cairo"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog README TODO"
