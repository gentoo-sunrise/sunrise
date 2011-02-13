# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils distutils

DESCRIPTION="Python module for reading and writing GRIB files (edition 1 and edition 2)"
HOMEPAGE="http://code.google.com/p/pygrib/ http://pypi.python.org/pypi/pygrib/"
SRC_URI="http://pygrib.googlecode.com/files/${P}.tar.gz"

LICENSE="pygrib"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="dev-python/numpy
	sci-libs/proj
	dev-python/matplotlib
	dev-python/basemap
	sci-libs/grib_api
	|| ( media-libs/jasper media-libs/openjpeg )
	media-libs/libpng
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
# patch already be applied by upstream, avoid conflict with grib_api's script
# ref http://code.google.com/p/pygrib/issues/detail?id=22
	epatch "${FILESDIR}"/${P}-fix_duplicate_name.patch
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml docs/* || die
	fi
}
