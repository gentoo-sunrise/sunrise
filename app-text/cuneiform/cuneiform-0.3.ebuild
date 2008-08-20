# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils eutils

DESCRIPTION="An enterprise quality OCR engine developed in USSR/Russia in the 90's."
HOMEPAGE="https://launchpad.net/cuneiform-linux"
SRC_URI="http://launchpad.net/${PN}-linux/${PV}/${PV}/+download/${P}.tar.bz2
		http://omploader.org/vb3Rs/${P}-pragma-fix.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

IUSE="imagemagick debug"

RDEPEND="imagemagick? ( media-gfx/imagemagick )"
DEPEND=">=dev-util/cmake-2.4.7
	${RDEPEND}"

DOCS="readme.txt"

src_unpack(){
	unpack ${A}
	cd "${S}"

	epatch "${WORKDIR}"/${P}-pragma-fix.patch
	epatch "${FILESDIR}"/${P}-no-imagemagic.patch
	# Fix automagic dependencies / linking
	if ! use imagemagick; then
		sed -e '/pkg_check_modules(MAGICK ImageMagick++)/s/^/#DONOTFIND /' \
			-i "${S}/cuneiform_src/Kern/CMakeLists.txt" \
		|| die "Sed for ImageMagick automagic dependency failed."
	fi
}

