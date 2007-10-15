# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="A three-dimensional finite element mesh generator with built-in pre- and post-processing facilities."
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc jpeg zlib png X metis cgns"

DEPEND="x11-libs/fltk
	sci-libs/gsl
	doc? ( app-text/tetex )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	zlib? ( sys-libs/zlib )"

RDEPEND="${DEPEND}"

src_compile() {
	econf \
		--disable-netgen \
		$(use_enable jpeg) \
		$(use_enable zlib) \
		$(use_enable png) \
		$(use_enable metis) \
		$(use_enable cgns) \
		$(use_enable X gui)  || die "could not configure"
	emake -j1 || die "emake failed"

	if use doc ; then
		cd doc/texinfo
		emake pdf || die "could not build documentation"
	fi
}

src_install() {
	einstall || die "could not install"
	dodoc README doc/CREDITS

	if use doc ; then
		dodoc doc/{FAQ,README.*,TODO,VERSIONS} doc/texinfo/*.pdf
	fi
}
