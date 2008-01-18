# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="A three-dimensional finite element mesh generator with built-in pre- and post-processing facilities."
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X cgns doc jpeg metis png zlib"

RDEPEND="sci-libs/gsl
	x11-libs/fltk
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	doc? ( app-text/tetex )"

src_compile() {
	econf \
		--disable-netgen \
		$(use_enable X gui) \
		$(use_enable cgns) \
		$(use_enable jpeg) \
		$(use_enable metis) \
		$(use_enable png) \
		$(use_enable zlib)

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
