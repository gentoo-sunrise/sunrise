# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils flag-o-matic

DESCRIPTION="Provides the necessary logic to capture screen recordings and to process them"
HOMEPAGE="http://libinstrudeo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	dev-cpp/libxmlpp:2.6
	media-libs/freetype
	dev-libs/glib:2
	dev-cpp/glibmm:2
	media-libs/freeglut
	media-libs/libvorbis
	media-libs/libdc1394:1
	media-libs/libdca
	media-libs/libtheora
	media-libs/ftgl
	virtual/ffmpeg
	media-sound/gsm
	net-misc/curl
	dev-libs/openssl
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}/${PV}-img_convert_to_sws_scale.patch"
	eautoreconf
	append-cxxflags -D__STDC_CONSTANT_MACROS
}
