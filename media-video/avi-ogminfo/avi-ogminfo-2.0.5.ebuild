# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils

DESCRIPTION="A small program for getting information about media files"
HOMEPAGE="http://avi-ogminfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="
	dev-libs/libxml2
	x11-libs/gtk+:2
	dev-cpp/gtkmm:2.4
	virtual/ffmpeg
	media-libs/libogg
	media-libs/libvorbis"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-ffmpeg.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-rpath
}
