# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils versionator

MY_PN="Songbird"
MY_PV=$(replace_version_separator 3 '-')

DESCRIPTION="A multimedia player, inspired by iTunes"
HOMEPAGE="http://www.songbirdnest.com/"
SRC_URI="amd64? (
http://download.songbirdnest.com/installer/linux/x86_64/${MY_PN}_${MY_PV}_linux-x86_64.tar.gz  )
	x86? ( http://download.songbirdnest.com/installer/linux/i686/${MY_PN}_${MY_PV}_linux-i686.tar.gz ) "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa esd faac faad ffmpeg flac gnome jpeg lame mpeg musepack ogg oss speex theora ugly vorbis"

RDEPEND="dev-libs/liboil
	media-libs/gst-plugins-base
	media-libs/gstreamer
	media-plugins/gst-plugins-mad
	media-plugins/gst-plugins-neon
	media-plugins/gst-plugins-x
	media-plugins/gst-plugins-xvideo
	net-misc/neon
	sys-libs/glibc
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
	alsa? ( media-plugins/gst-plugins-alsa )
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
	ogg? ( media-plugins/gst-plugins-ogg
		theora? ( media-plugins/gst-plugins-theora )
		vorbis? ( media-plugins/gst-plugins-vorbis )
	)
	oss? ( media-plugins/gst-plugins-oss )
	speex? ( media-plugins/gst-plugins-speex )
	ugly?  ( media-libs/gst-plugins-ugly )"

S=${WORKDIR}/${MY_PN}

RESTRICT="strip"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2.0-symlink.patch"
}

src_install() {
	einfo "unbundling gst, theora and vorbis libs"
	find lib \( \
		-name "libgst*" -o -name "libtheora*" -o \
		-name "libvorbis*" -o -name "libogg*" -o \
		-name "libFLAC*" \) -delete || die
	insinto /opt/songbird
	doins -r * || die
	fperms 755 /opt/songbird/songbird || die
	fperms 755 /opt/songbird/songbird-bin || die
	dosym /opt/songbird/songbird /opt/bin/songbird-bin || die

	newicon "${S}"/chrome/icons/default/default.xpm ${PN}.xpm || die
	make_desktop_entry ${PN} ${PN} ${PN}.xpm "AudioVideo;Player"
}

pkg_postinst() {
	einfo "The Linux branch of songbird is no longer under active development,"
	einfo "bug 139019 is RESOLVED/WONTFIX according to this. Please see"
	einfo "http://blog.songbirdnest.com/2010/04/02/songbird-singing-a-new-tune/"
	einfo "for details."
	einfo "If you need other music/video plugins, search for"
	einfo "media-plugins/gst-plugins-*, but some might not be supported."
}
