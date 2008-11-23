# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PN="Songbird"
MY_PV="${PV/_/}-856"

DESCRIPTION="A multimedia player, inspired by iTunes"
HOMEPAGE="http://www.songbirdnest.com/"
SRC_URI="x86? ( http://download.songbirdnest.com/installer/linux/i686/${MY_PN}_${MY_PV}_linux-i686.tar.gz )
	amd64? ( http://download.songbirdnest.com/installer/linux/x86_64/${MY_PN}_${MY_PV}_linux-x86_64.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa esd faac faad ffmpeg flac gnome jpeg lame mpeg musepack ogg oss speex theora ugly vorbis"

RDEPEND="alsa? ( media-plugins/gst-plugins-alsa )
	esd?  ( media-plugins/gst-plugins-esd )
	faac? ( media-plugins/gst-plugins-faac )
	faad? ( media-plugins/gst-plugins-faad )
	ffmpeg? ( media-plugins/gst-plugins-ffmpeg )
	flac? ( media-plugins/gst-plugins-flac )
	gnome? ( media-plugins/gst-plugins-gconf
		media-plugins/gst-plugins-gnomevfs )
	jpeg? ( media-plugins/gst-plugins-jpeg )
	lame? ( media-plugins/gst-plugins-lame )
	mpeg? ( media-plugins/gst-plugins-mpeg2dec )
	musepack? ( media-plugins/gst-plugins-musepack )
	ogg? ( media-plugins/gst-plugins-ogg )
	oss?  ( media-plugins/gst-plugins-oss )
	speex? ( media-plugins/gst-plugins-speex )
	theora? ( media-plugins/gst-plugins-ogg
		media-plugins/gst-plugins-theora )
	ugly?  ( media-libs/gst-plugins-ugly )
	vorbis? ( media-plugins/gst-plugins-ogg
		media-plugins/gst-plugins-vorbis )
	x11-libs/libXdmcp
	x11-libs/libXau
	x11-libs/libXfixes
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/pango
	dev-libs/liboil
	media-libs/gstreamer
	media-libs/gst-plugins-base
	media-plugins/gst-plugins-x
	media-plugins/gst-plugins-xvideo
	media-plugins/gst-plugins-mad
	>=net-misc/neon-0.26.4
	media-plugins/gst-plugins-neon
	>=sys-libs/glibc-2.3.2
	>=x11-libs/gtk+-2.0.0
	>=virtual/xft-7.0
	>=virtual/libstdc++-3.3"

S=${WORKDIR}/${MY_PN}

RESTRICT="strip"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-1.0.0_rc2-symlink.patch
}

src_install() {
	insinto /opt/songbird
	doins -r *
	fperms 755 /opt/songbird/songbird
	fperms 755 /opt/songbird/songbird-bin
	dosym /opt/songbird/songbird /opt/bin/songbird-bin

	newicon "${S}"/chrome/icons/default/default.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN}.xpm "AudioVideo;Player"
}

pkg_postinst() {
	echo
	ewarn "Songbird is still under development!"
	ewarn "This ebuild is not supported by Gentoo, so"
	ewarn "please do not send any bugs at Gentoo's bugzilla."
	einfo "If you need help, find it there:"
	einfo "http://tnij.org/songbird-community"
	einfo "or"
	einfo "http://tnij.org/songbird-at-fgo"
	einfo ""
	einfo "If You need other music/video plugins, look at"
	einfo "Your portage tree into media-plugins/gst-plugins-*,"
	einfo "but remember, that not all plugins are supported yet."
	einfo ""
	einfo "If You don't want too much deps on it package,"
	einfo "disable gnome support"
	echo
}

