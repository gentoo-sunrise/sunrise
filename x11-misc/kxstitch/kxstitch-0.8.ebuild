# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde

DESCRIPTION="A program to create cross stitch patterns and charts"
HOMEPAGE="http://kxstitch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick scanner"

DEPEND="imagemagick? ( media-gfx/imagemagick )
	scanner? ( media-gfx/sane-backends )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use imagemagick && built_with_use media-gfx/imagemagick nocxx ; then
		eerror "Building kxstitch requires imagemagcik built without"
		eerror "the nocxx use flag to build magick++ (the C++ API)."
		eerror "Please re-emerge imagemagick with this use flag disabled."
		die "imagemagick missing magick++"
	fi
}
