# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://live.gnome.org/Cheese"
SRC_URI="http://live.gnome.org/Cheese/Releases?action=AttachFile&do=get&target=${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-libs/glib-2.12
	>=x11-libs/gtk+-2.10.0
	>=gnome-base/libglade-2.0.0
	>=media-libs/gstreamer-0.10.12"

DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog README TODO"
