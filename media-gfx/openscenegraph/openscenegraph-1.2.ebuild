# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib toolchain-funcs

MY_PN=OpenSceneGraph
MY_PV=${PV/_rc/-rc}

DESCRIPTION="Cross-platform, high performance 3D graphics toolkit"
HOMEPAGE="http://www.openscenegraph.org/"
SRC_URI="http://www.openscenegraph.org/downloads/snapshots/OSG_OP_OT-${MY_PV}.zip"

LICENSE="OSGPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples introspection producer gdal jasper truetype xine jpeg gif tiff png coin inventor glut"

RDEPEND=">=dev-libs/openproducer-1.0.2
	>=dev-libs/openthreads-1.4.3
	media-libs/mesa
	virtual/opengl
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libX11
	gdal? ( sci-libs/gdal )
	jasper? ( media-libs/jasper )
	truetype? ( media-libs/freetype )
	xine? ( media-libs/xine-lib )
	jpeg? ( media-libs/jpeg )
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff )
	png? ( media-libs/libpng
				sys-libs/zlib )
	coin? ( media-libs/coin )
	inventor? ( media-libs/openinventor )
	glut? ( virtual/glut )"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/OSG_OP_OT-${MY_PV}/${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	local myconf

	use introspection \
		&& myconf="${myconf} COMPILE_INTROSPECTION=yes" \
		|| myconf="${myconf} COMPILE_INTROSPECTION=no"

	use producer \
		&& myconf="${myconf} PRODUCER_INSTALLED=yes" \
		|| myconf="${myconf} PRODUCER_INSTALLED=no"

	use examples \
		&& myconf="${myconf} COMPILE_EXAMPLES=yes" \
		|| myconf="${myconf} COMPILE_EXAMPLES=no"

	use gdal \
		&& myconf="${myconf} GDAL_INSTALLED=yes" \
		|| myconf="${myconf} GDAL_INSTALLED=no"

	use jasper \
		&& myconf="${myconf} JASPER_INSTALLED=yes" \
		|| myconf="${myconf} JASPER_INSTALLED=no"

	use truetype \
		&& myconf="${myconf} FREETYPE_INSTALLED=yes" \
		|| myconf="${myconf} FREETYPE_INSTALLED=no"

	use xine \
		&& myconf="${myconf} XINE_INSTALLED=yes" \
		|| myconf="${myconf} XINE_INSTALLED=no"

	myconf="${myconf} QUICKTIME_INSTALLED=no"

	use jpeg \
		&& myconf="${myconf} LIBJPEG_INSTALLED=yes" \
		|| myconf="${myconf} LIBJPEG_INSTALLED=no"

	use gif \
		&& myconf="${myconf} LIBUNGIF_INSTALLED=yes" \
		|| myconf="${myconf} LIBUNGIF_INSTALLED=no"

	use tiff \
		&& myconf="${myconf} LIBTIFF_INSTALLED=yes" \
		|| myconf="${myconf} LIBTIFF_INSTALLED=no"

	use png \
		&& myconf="${myconf} LIBPNG_INSTALLED=yes" \
		|| myconf="${myconf} LIBPNG_INSTALLED=no"

	use coin \
		&& myconf="${myconf} COIN_INSTALLED=yes" \
		|| myconf="${myconf} COIN_INSTALLED=no"

	use inventor \
		&& myconf="${myconf} INVENTOR_INSTALLED=yes" \
		|| myconf="${myconf} INVENTOR_INSTALLED=no"

	myconf="${myconf} PERFORMER_INSTALLED=no"

	use glut \
		&& myconf="${myconf} GLUT_INSTALLED=yes" \
		|| myconf="${myconf} GLUT_INSTALLED=no"

	emake CXX=$(tc-getCXX) ${myconf} || die "emake failed"

	if use doc; then
		OSGHOME="${S}" doxygen doc/Doxyfiles/all_Doxyfile
	fi
}

src_install() {
	emake INST_LOCATION="${D}"/usr INST_EXAMPLES="${D}"/usr/bin \
		INST_EXAMPLE_SRC="${D}"/usr/share/doc/${P}/examples \
		INST_SRC="${D}"/usr/share/doc/${P}/src install \
		|| die "emake install failed"

	insinto /usr/$(get_libdir)/pkgconfig
	doins Make/openscenegraph.pc

	dodoc AUTHORS.txt ChangeLog NEWS.txt README.txt

	if use doc; then
		dodoc doc/ProgrammingGuide/ProgrammingGuide.odt
		dohtml -r doc/doxygen/html
	fi
}
