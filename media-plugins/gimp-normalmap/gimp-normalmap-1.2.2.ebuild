# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Gimp plug-in for converting images into RGB normal maps"
HOMEPAGE="http://code.google.com/p/gimp-normalmap/"
SRC_URI="http://gimp-normalmap.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-gfx/gimp
	media-libs/glew
	x11-libs/gtkglext"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -e 's:CFLAGS=.*`:CFLAGS+=`:' \
	    -e 's:LDFLAGS=:LDFLAGS+=:' \
		-e 's:-L/usr/X11R6/lib::' \
		-i Makefile.linux || die

	# Fixing incorrect $(LD) usage
	# http://code.google.com/p/gimp-normalmap/issues/detail?id=1
	sed -e 's:\t$(LD) :\t$(CC) :' \
		-i Makefile.linux || die
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	exeinto $(pkg-config --variable=gimplibdir gimp-2.0)/plug-ins
	doexe normalmap || die "Installation failed"
	dodoc README || die
}

pkg_postinst() {
	elog "The GIMP normalmap plugin is accessible from the menu:"
	elog "Filters -> Map -> Normalmap"
}
