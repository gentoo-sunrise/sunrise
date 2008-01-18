# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PN="Songbird"
MY_PV="$(replace_all_version_separators _ )"

DESCRIPTION="Songbird is a desktop Web player, a digital jukebox and Web browser mash-up"
HOMEPAGE="http://www.songbirdnest.com/"
SRC_URI="x86? ( http://download.songbirdnest.com/installer/linux/i686/${MY_PN}_${MY_PV}_linux-i686.tar.gz )
	amd64? ( http://download.songbirdnest.com/installer/linux/x86_64/${MY_PN}_${MY_PV}_linux-x86_64.tar.gz ) "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg dvd flac mad mpeg ogg theora vorbis"

#gstreamer deps are a mix of
# - a copy of totem and
# - http://publicsvn.songbirdnest.com/trac/wiki/SettingUpGStreamer

#local useflags?
#lame? (>=media-plugins/gst-plugins-lame-0.10)
#faad? (>=media-plugins/gst-plugins-faad-0.10)
#faac? (>=media-plugins/gst-plugins-faac-0.10)
#IUSE="lame faad faac"
#how about ugly?

# pitdfdll has not come out with a 0.10 release, should be soon though -AJL
# IUSE="win32codecs"
# win32codecs? ( >=media-plugins/gst-plugins-pitfdll-0.10 )

DEPEND=""
RDEPEND="x11-libs/libXdmcp
	x11-libs/libXau
	x11-libs/libXfixes
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/pango
	>=x11-libs/gtk+-2.0.0
	>=virtual/xft-7.0
	>=virtual/libstdc++-3.3
	>=media-libs/gstreamer-0.10.1
	>=media-libs/gst-plugins-base-0.10
	>=media-plugins/gst-plugins-xvideo-0.10
	>=media-plugins/gst-plugins-x-0.10
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-gnomevfs-0.10
	>=media-libs/gst-plugins-good-0.10
	>=media-plugins/gst-plugins-pango-0.10
	>=media-libs/gst-plugins-ugly-0.10
	ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10 )
	mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-0.10 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10 )
	mad? ( >=media-plugins/gst-plugins-mad-0.10 )
	ogg? ( >=media-plugins/gst-plugins-ogg-0.10 )
	theora? (
		>=media-plugins/gst-plugins-ogg-0.10
		>=media-plugins/gst-plugins-theora-0.10
	)
	vorbis? (
		>=media-plugins/gst-plugins-ogg-0.10
		>=media-plugins/gst-plugins-vorbis-0.10
	)"

S=${WORKDIR}/${MY_PN}

RESTRICT="strip"

src_install() {
	insinto /opt/songbird
	doins -r *
	fperms 755 /opt/songbird/Songbird
	fperms 755 /opt/songbird/xulrunner/xulrunner
	fperms 755 /opt/songbird/xulrunner/xulrunner-bin
	dosym /opt/songbird/Songbird /opt/bin/songbird-bin

	newicon "${S}/chrome/icons/default/default.xpm" ${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN}.xpm "AudioVideo;Player"
}
