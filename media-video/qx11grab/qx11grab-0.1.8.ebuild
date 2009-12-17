# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

DESCRIPTION="X11 desktop video grabber tray"
HOMEPAGE="http://qx11grab.hjcms.de/?ref=welcome&lang=en"
SRC_URI="http://qx11grab.hjcms.de/Downloads/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4[dbus]"
RDEPEND="${DEPEND}
	media-video/ffmpeg[X]"
