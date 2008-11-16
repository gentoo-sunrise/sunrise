# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

EAPI=1

MY_P=${P/graphicsm/GraphicsM}

DESCRIPTION="A collection of tools and libraries for many image formats"
HOMEPAGE="http://www.graphicsmagick.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 cxx debug fpx imagemagick jbig +jpeg +jpeg2k lcms openmp
	perl +png q16 q32 +svg +threads tiff +truetype X wmf zlib"

DEPEND="bzip2? ( app-arch/bzip2 )
	fpx? ( media-libs/libfpx )
	virtual/ghostscript
	jbig? ( media-libs/jbigkit )
	jpeg? ( media-libs/jpeg )
	jpeg2k? ( >=media-libs/jasper-1.701.0 )
	lcms? ( media-libs/lcms )
	media-video/mpeg2vidcodec
	perl? ( dev-lang/perl )
	png? ( media-libs/libpng )
	svg? ( dev-libs/libxml2 )
	tiff? ( >=media-libs/tiff-3.8.2 )
	truetype? ( >=media-libs/freetype-2.0 )
	wmf? ( media-libs/libwmf )
	X? ( x11-libs/libXext
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libICE )
	imagemagick? ( !media-gfx/imagemagick )"
S=${WORKDIR}/${MY_P}

src_compile() {
	local quantumDepth="--with-quantum-depth="
	if use q16 ; then
		quantumDepth="${quantumDepth}16"
	elif use q32 ; then
		quantumDepth="${quantumDepth}32"
	else
		quantumDepth="${quantumDepth}8"
	fi

	use debug && filter-flags -fomit-frame-pointer

	econf \
		${quantumDepth} \
		$( use_enable imagemagick magick-compat ) \
		$( use_enable openmp ) \
		$( use_with bzip2 bzlib ) \
		$( use_with fpx ) \
		$( use_with jbig ) \
		$( use_with jpeg ) \
		$( use_with jpeg2k jp2 ) \
		$( use_with lcms ) \
		$( use_with cxx magick-plus-plus ) \
		$( use_with perl ) \
		$( use_with png ) \
		$( use_with tiff ) \
		$( use_with truetype ttf ) \
		$( use_with X x ) \
		$( use_with svg xml ) \
		$( use_with wmf ) \
		$( use_with zlib ) \
		$( use_with threads ) \
		$( use_enable debug ccmalloc ) \
		$( use_enable debug prof ) \
		$( use_enable debug gcov ) \
		--disable-gprof \
		--enable-largefile \
		--without-included-ltdl \
		--without-gslib \
		--without-dps \
		--without-umem \
		--without-trio \
		--with-modules \
		--enable-shared

	emake || die "Build failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc README.txt ChangeLog* || die "dodoc failed."
}

pkg_postinst() {
	elog "For RAW image suport please install media-gfx/dcraw."
	elog "To read gnuplot files please install sci-visualization/gnuplot."
	if use openmp && !( built_with_use sys-devel/gcc openmp ); then
		elog "GraphicsMagick was not compiled with OpenMP."
		elog "To get OpenMP support build your GCC with openmp USE flag."
		elog "You need GCC 4.2.0 or greater for OpenMP."
	fi
}
