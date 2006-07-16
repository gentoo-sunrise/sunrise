# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Provides the necessary logic to capture screen recordings and to process them"
HOMEPAGE="http://libinstrudeo.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-cpp/libxmlpp-2.10.0
	>=media-libs/freetype-2.1.9
	>=dev-libs/glib-2.10.0
	>=dev-cpp/glibmm-2.8.4
	media-libs/libvorbis
	media-libs/libdc1394
	media-libs/libdts
	media-libs/libtheora
	media-libs/ftgl
	media-video/ffmpeg
	media-sound/gsm
	net-misc/curl
	dev-libs/openssl
	sys-libs/zlib
	virtual/glut"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PV}-font_commentboxes_path.patch"
	cd "${S}"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
