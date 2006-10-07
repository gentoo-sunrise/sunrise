# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PN="Songbird"
MY_PV="$(replace_version_separator 1 '_')_RC2"
S="${WORKDIR}/${MY_PN}_20061003"

DESCRIPTION="A multimedia player, inspired by iTunes"
HOMEPAGE="http://www.songbirdnest.com"
SRC_URI="http://download.songbirdnest.com/installer/linux/i686/${MY_PN}_${MY_PV/_rc2/}_linux-i686.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="strip"
DEPEND=""
RDEPEND=" x11-libs/libXdmcp
		x11-libs/libXau
		x11-libs/libXfixes
		x11-libs/libXcursor
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXext
		x11-libs/libX11
		>=media-libs/gstreamer-0.8
		>=sys-libs/glibc-2.3.2
	 	>=x11-libs/gtk+-2.0.0
	 	>=virtual/xft-7.0
	 	>=virtual/libstdc++-3.3
		x11-libs/pango"

src_install() {
	insinto /usr/lib/songbird
	doins -r *
	fperms 755 /usr/lib/songbird/Songbird
	fperms 755 /usr/lib/songbird/xulrunner/xulrunner
	fperms 755 /usr/lib/songbird/xulrunner/xulrunner-bin
	newbin "${FILESDIR}/${PV}"/songbird-launcher.sh songbird

	newicon ${S}/xulrunner/icons/mozicon16.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN}.xpm "AudioVideo;Player"
}