# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WX_GTK_VER="2.8"
inherit cmake-utils wxwidgets

DESCRIPTION="Music player using wxWidgets designed to be intuitive and fast"
HOMEPAGE="http://sourceforge.net/projects/guayadeque/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/taglib
	dev-db/sqlite:3
	net-misc/curl
	media-libs/gstreamer
	x11-libs/wxGTK:2.8[gstreamer]
	media-libs/flac
	sys-apps/dbus"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"
