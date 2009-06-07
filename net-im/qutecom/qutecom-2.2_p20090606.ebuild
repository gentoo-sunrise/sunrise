# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils eutils

DESCRIPTION="Multi-protocol instant messenger and VoIP client"
HOMEPAGE="http://www.qutecom.com/"
SRC_URI="http://omploader.org/vMXNucg/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug oss portaudio xv"

DEPEND=">=dev-libs/boost-1.34
	dev-libs/glib
	dev-libs/openssl
	alsa? ( media-libs/alsa-lib )
	media-libs/libsamplerate
	media-libs/libsndfile
	portaudio? ( media-libs/portaudio )
	media-libs/speex
	media-video/ffmpeg
	net-im/pidgin[gnutls]
	net-libs/gnutls
	>=net-libs/libosip-3
	>=net-libs/libeXosip-3
	net-misc/curl
	|| ( x11-libs/libX11 virtual/x11 )
	x11-libs/qt-gui
	x11-libs/qt-svg
	xv? ( x11-libs/libXv )"
RDEPEND=${DEPEND}

src_configure() {
	local mycmakeargs="$(cmake-utils_use_enable portaudio PORTAUDIO_SUPPORT) \
		$(cmake-utils_use_enable alsa PHAPI_AUDIO_ALSA_SUPPORT) \
		$(cmake-utils_use_enable oss PHAPI_AUDIO_OSS_SUPPORT) \
		$(cmake-utils_use_enable xv WENGOPHONE_XV_SUPPORT) \
		-DLIBPURPLE_INTERNAL=OFF \
		-DPORTAUDIO_INTERNAL=OFF "

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	domenu wengophone/res/${PN}.desktop || die "domenu failed"
	doicon wengophone/res/${PN}_64x64.png || die "doicon failed"

}
