# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Synfig: Film-Quality Vector Animation (core engine)"
HOMEPAGE="http://www.synfig.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# automagic dependencies are not acceptable
IUSE="dv fontconfig ffmpeg imagemagick openexr truetype" # jpeg png tiff

DEPEND=">=dev-libs/libsigc++-2.0.0
	>=dev-cpp/libxmlpp-2.6.1
	>=dev-cpp/ETL-0.04.10
	media-libs/jpeg
	media-libs/tiff
	media-libs/libpng
	dv? ( media-libs/libdv )
	ffmpeg? ( media-video/ffmpeg )
	fontconfig? ( media-libs/fontconfig )
	imagemagick? ( media-gfx/imagemagick )
	openexr? ( media-libs/openexr )
	truetype? ( >=media-libs/freetype-2.1.9 )"

src_compile() {
	econf \
		$(use_with ffmpeg ) \
		$(use_with ffmpeg libavcodec ) \
		$(use_with fontconfig) \
		$(use_with imagemagick) \
		$(use_with dv libdv) \
		$(use_with openexr ) \
		$(use_with truetype freetype)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
	dodoc doc/*.txt
	insinto /usr/share/${PN}/examples
	doins examples/*.sif
}
