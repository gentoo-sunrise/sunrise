# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils eutils qt4

DESCRIPTION="Records Skype calls to MP3/Ogg/WAV files"
HOMEPAGE="http://atdot.ch/scr/"
SRC_URI="http://atdot.ch/scr/files/${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	|| (
		x11-libs/qt-gui:4[dbus]
		=x11-libs/qt-4.3*:4
	)
	media-sound/lame
	media-libs/id3lib
	>=media-libs/libvorbis-1.2.0
	sys-apps/dbus"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8"

QT4_BUILT_WITH_USE_CHECK="dbus"

pkg_setup() {
	qt4_pkg_setup

	if built_with_use net-im/skype qt-static; then
		ewarn "WARNING: net-im/skype was built with the 'qt-static' USE flag!  Skype Call"
		ewarn "Recorder won't be able to connect to Skype!  Reinstall Skype without"
		ewarn "'qt-static' to make it work."
	fi
}

