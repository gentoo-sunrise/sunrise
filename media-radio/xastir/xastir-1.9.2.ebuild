# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="X Amateur Station Tracking and Information Reporting"
HOMEPAGE="http://xastir.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="festival gdal geotiff imagemagick"

DEPEND="x11-libs/openmotif
	x11-libs/libXpm
	dev-libs/libpcre
	net-misc/curl
	sys-libs/db
	sci-libs/shapelib
	geotiff? ( sci-libs/proj
		sci-libs/libgeotiff
		media-libs/tiff )
	gdal? ( sci-libs/gdal )
	imagemagick? ( >=media-gfx/imagemagick-6.4 )
	festival? ( app-accessibility/festival )"


src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix some scripts with DOS line endings
	edos2unix scripts/toporama*
	# support for new imagemagick,
	# correction for selection of curl library in configure.ac and
	# fix for different install directory in scripts
	epatch "${FILESDIR}/${P}-IM.diff" \
		"${FILESDIR}/${P}-curl.diff" \
		"${FILESDIR}/${P}-scripts.diff"
	eautoreconf
}

src_compile() {
	econf --without-graphicsmagick \
		--with-pcre \
		--with-shapelib \
		--with-dbfawk \
		--without-ax25 \
		--without-gpsman \
		$(use_with geotiff libproj) \
		$(use_with geotiff) \
		$(use_with gdal) \
		$(use_with imagemagick) \
		$(use_with festival)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	elog "Kernel mode AX.25 not supported."
	elog "GPSman library not supported."
	elog
	elog "Remember you have to be root to add addditional scripts,"
	elog "maps and other configuration data under /usr/share/xastir"
	elog "/usr/lib/xastir."
}
