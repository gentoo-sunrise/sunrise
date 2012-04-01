# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Convert any images into MPEG video streams with transitions between the images"
HOMEPAGE="http://www.gromeck.de/projekte/software/image2mpeg/"
SRC_URI="http://www.gromeck.de/uploads/media/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug devil"

DEPEND="
	media-libs/libmad
	media-libs/libpng
	media-video/mjpegtools
	virtual/ffmpeg
	!devil? ( >=media-gfx/imagemagick-6.1.8 )
	devil? ( >=media-libs/devil-1.7.0 )"
RDEPEND="${DEPEND}
	media-sound/madplay
	>=media-sound/toolame-0.2l"

src_configure(){
	econf \
		$(use_enable debug) \
		$(use_enable devil)
}
