# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Film-Quality Vector Animation (core engine)"
HOMEPAGE="http://www.synfig.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc dv ffmpeg fontconfig imagemagick jpeg png tiff truetype openexr"

DEPEND=">=dev-cpp/ETL-0.04.08
	>=dev-libs/libsigc++-2.0.0
	>=dev-cpp/libxmlpp-2.6.1
	sys-devel/libtool
	doc? ( app-doc/doxygen )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	jpeg? ( media-libs/jpeg )
	truetype? ( >=media-libs/freetype-2.1.9 )
	fontconfig? ( media-libs/fontconfig )
	dv? ( media-libs/libdv )
	imagemagick? ( media-gfx/imagemagick )
	openexr? ( media-libs/openexr )
	ffmpeg? ( media-video/ffmpeg )"

src_compile() {
	./bootstrap || die 'Bootstrap failed.'
	econf \
		$(use_with ffmpeg) \
		$(use_with dv libdv) \
		$(use_with imagemagick) \
		--without-libavcodec \
		$(use_with fontconfig) \
		$(use_with truetype freetype) \
		$(use_with openexr) \
		$(use_with debug) \
		|| die 'Configure failed.'
	emake || die 'Make failed.'
	if use doc; then
		emake docs || die "make docs failed."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die 'Install failed!'
	dodoc doc/*.txt
	if use doc; then
		dohtml doc/html/*
	fi
	insinto "/usr/share/${PN}/examples"
	doins examples/*.sif
	insinto "/usr/share/${PN}/examples/walk"
	doins examples/walk/*
}
