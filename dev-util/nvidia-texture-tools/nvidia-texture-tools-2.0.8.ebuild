# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils eutils multilib

DESCRIPTION="A set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
SRC_URI="http://${PN}.googlecode.com/files/${P}-1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg cuda glew glut openexr static"

DEPEND="media-libs/libpng:0
	media-libs/ilmbase
	media-libs/tiff
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11
	cg? ( media-gfx/nvidia-cg-toolkit )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	glew? ( media-libs/glew )
	glut? ( media-libs/freeglut )
	openexr? ( media-libs/openexr )
	"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/gcc4.4.4-aliasing.patch \
		"${FILESDIR}"/libpng1.5-build.patch \
		"${FILESDIR}"/valgrind.patch \
		"${FILESDIR}"/cuda.patch \
		"${FILESDIR}"/libtiff4.patch \
		"${FILESDIR}"/${P}-cmake.patch
}

src_configure() {
	local mycmakeargs=(
		-DLIBDIR=$(get_libdir)
		$(cmake-utils_use cg CG)
		$(cmake-utils_use cuda CUDA)
		$(cmake-utils_use glew GLEW)
		$(cmake-utils_use glut GLUT)
		$(cmake-utils_use openexr OPENEXR)
		$(cmake-utils_use !static NVTT_SHARED)
		)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc ChangeLog
}
