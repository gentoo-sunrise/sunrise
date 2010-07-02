# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"

inherit python

DESCRIPTION="A generic A/V API that relies on various multimedia player"
HOMEPAGE="http://libplayer.geexbox.org/"

SRC_URI="http://${PN}.geexbox.org/releases/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="X debug doc gstreamer mplayer python static vlc xine"

RDEPEND="gstreamer? ( media-libs/gstreamer )
	mplayer? ( media-video/mplayer )
	vlc? ( media-video/vlc )
	xine? ( media-libs/xine-lib )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

RESTRICT_PYTHON_ABIS="3.*"

src_configure() {
	# . econf fails because the configure script doesn't
	#   recognize options like --build and --host
	# . upstream "optimize" option simply adds -O3
	# . python bindings are installed manually to support
	#   multiple python versions

	./configure \
		--prefix=/usr \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_enable gstreamer) \
		$(use_enable mplayer) \
		$(use_enable vlc) \
		$(use_enable xine) \
		$(use_enable X x11) \
		$(use_enable static) \
		--disable-binding-python \
		--disable-optimize \
		--disable-strip \
		--enable-shared \
		|| die "configure failed"
}

src_compile() {
	default

	if use python; then
		python_copy_sources bindings/python

		building() {
			emake BINDING_PYTHON="yes" \
				DESTDIR="${D}" \
				PYTHON="$(PYTHON)" \
				PYTHON_INCLUDEDIR="$(python_get_includedir)" \
				PYTHON_LIBDIR="$(python_get_libdir)" \
				|| die "emake failed"
		}
		python_execute_function -s --source-dir bindings/python building
	fi
}

src_install() {
	# without -j1 it (often) fails
	emake -j1 DESTDIR="${D}" install || die "Install failed"

	if use python; then
		installing() {
			emake BINDING_PYTHON="yes" \
				DESTDIR="${D}" \
				PKG_CONFIG_PATH="../../" \
				PYTHON="$(PYTHON)" \
				PYTHON_INCLUDEDIR="$(python_get_includedir)" \
				PYTHON_LIBDIR="$(python_get_libdir)" \
				install \
				|| die "emake failed"
		}
		python_execute_function -s --source-dir bindings/python installing
	fi

	dodoc AUTHORS ChangeLog README || die "dodoc failed"
}
