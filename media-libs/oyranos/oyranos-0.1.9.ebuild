# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Color Management System (CMS) on the operating system level"
HOMEPAGE="http://www.oyranos.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc X xinerama"

RDEPEND="app-admin/elektra
	dev-libs/libxml2
	media-libs/jpeg
	media-libs/lcms
	media-libs/libpng
	sys-devel/gettext
	sys-devel/libtool
	sys-libs/zlib
	virtual/opengl
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/fltk:1.1
		xinerama? ( x11-libs/libXinerama )
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	X? ( x11-proto/xf86vidmodeproto
		xinerama? ( x11-proto/xineramaproto )
	)"

src_prepare() {
	# remove X11R6/g++ from include/lib paths
	sed -i -e 's:/X11R6::' configure{,.sh} {,fl_i18n/}makefile.in || die
	sed -i -e 's: -I/usr/include/g++ : :' fl_i18n/makefile.in

	# leave custom flags untouched, do not remove -O1 from LDFLAGS=-Wl,-O1
	sed -i -e 's:STRIPOPT="sed s/-O.//":STRIPOPT="cat":' configure || die
	sed -i -e 's:s/-O.// ;::' configure.sh || die

	# ${S}/oyranos-config is not in PATH
	sed -i -e 's:oyranos-config :./\0:' configure.sh makefile.in || die

	# force version number at /usr/share/doc
	sed -i -e 's:$(datadir)/doc/$(TARGET):\0-$(VERSION):' makefile.in || die

	# configure.sh calls doxygen --help which is not needed w/o USE=doc, silence QA 
	use doc || { sed -i -e 's:doxygen:#\0:' configure.sh || die ; }
}

src_configure() {
	tc-export CC CXX
	econf $(use_enable debug) \
		$(use_enable X libX11) \
		$(use_enable X libXext) \
		$(use_enable X libXxf86vm) \
		$(use_enable xinerama libXinerama)
}

src_compile() {
	emake lib${PN}.so.${PV} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install_bin || die
	emake DESTDIR="${D}" install_linguas || die
	emake DESTDIR="${D}" install-icc || die
	if use doc ; then
		emake DESTDIR="${D}" install_docu || die
		rm "${D}/usr/share/doc/${P}/COPYING" || die
	fi
	dodoc AUTHORS ChangeLog README || die
}
