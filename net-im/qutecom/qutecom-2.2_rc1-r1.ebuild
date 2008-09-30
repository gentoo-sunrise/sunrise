# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils eutils

MY_P=${P/_rc/-RC}

DESCRIPTION="An open source softphone"
HOMEPAGE="http://www.qutecom.com/"
SRC_URI="http://www.qutecom.com/downloads/${MY_P}.tar.gz"

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
	portaudio? ( >=media-libs/portaudio-19_pre )
	media-libs/speex
	>=media-video/ffmpeg-0.4.9_p20080326
	net-libs/gnutls
	>=net-libs/libosip-3
	net-misc/curl
	|| ( x11-libs/libX11 virtual/x11 )
	|| ( ( x11-libs/qt-gui:4 x11-libs/qt-svg:4 ) =x11-libs/qt-4.3* )
	xv? ( x11-libs/libXv )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-boost-1.35.patch
	epatch "${FILESDIR}"/${PN}-types.h.patch
	epatch "${FILESDIR}"/${PN}-cstdlib-include.patch
	epatch "${FILESDIR}"/${PN}-gcc-4.3-switch-enum.patch
	epatch "${FILESDIR}"/${PN}-newerffmpeg0.patch
	epatch "${FILESDIR}"/${PN}-newerffmpeg1.patch
	epatch "${FILESDIR}"/${PN}-newerffmpeg2.patch
	epatch "${FILESDIR}"/${PN}-cmake-hg-svnrevision.patch
}

src_compile() {
	EXTRA_ECONF=" \
		$(cmake-utils_use_enable portaudio PORTAUDIO_SUPPORT) \
		$(cmake-utils_use_enable alsa PHAPI_AUDIO_ALSA_SUPPORT) \
		$(cmake-utils_use_enable oss PHAPI_AUDIO_OSS_SUPPORT) \
		$(cmake-utils_use_enable xv WENGOPHONE_XV_SUPPORT) "

	cmake-utils_src_configureout
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
	domenu wengophone/res/wengophone.desktop || die "domenu failed"
	doicon wengophone/res/wengophone_64x64.png || die "doicon failed"
}
