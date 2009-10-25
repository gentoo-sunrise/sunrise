# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit nsplugins multilib

DESCRIPTION="VRML97 library"
HOMEPAGE="http://openvrml.org"
SRC_URI="mirror://sourceforge/openvrml/${P}.tar.gz"

LICENSE="BSD GPL-2 LGPL-2.1 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples jpeg nsplugin opengl player png truetype xembed"
# java and javascript are disabled at the moment since they need some more fiddling

# about the use-flag controlled dependencies:
# * the embedded control xembed requires opengl
# * the player requires xembed
# * the nsplugin requires xembed
# the dependencies are done so that this can be resolved automatically
# in the configure phase, all required functionality is then switched on

RDEPEND="dev-libs/libxml2
	>=dev-libs/boost-1.37
	>=dev-libs/glib-2.6
	sys-libs/zlib
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	truetype? ( >=media-libs/freetype-2 media-libs/fontconfig )
	opengl? ( virtual/opengl virtual/glut )
	xembed? ( x11-libs/gtk+ x11-libs/gtkglext
		virtual/opengl virtual/glut )
	player? ( gnome-base/libgnomeui >=gnome-base/libgnome-2.14.1 gnome-base/libglade net-misc/curl
		x11-libs/gtk+ x11-libs/gtkglext
		virtual/opengl virtual/glut )
	nsplugin? ( net-libs/xulrunner
		x11-libs/gtk+ x11-libs/gtkglext
		virtual/opengl virtual/glut )
	examples? ( media-libs/libsdl )"

DEPEND="${RDEPEND}
	app-doc/doxygen"

src_configure() {
	local myconf="--with-x \
		$(use_enable png png-textures) \
		$(use_enable jpeg jpeg-textures) \
		--disable-script-node-java \
		--disable-script-node-javascript \
		$(use_enable truetype render-text-node) \
		$(use_enable examples)"

	if use opengl || use xembed || use player || use nsplugin ; then
		myconf="${myconf} --enable-gl-renderer"
		if ! use opengl ; then
			elog ""
			elog "Use-flags xembed, player, and nsplugin require opengl functionality."
			elog "Activating it automatically..."
			elog "To silence this message, activate use-flag opengl."
			elog ""
		fi
	else
		myconf="${myconf} --disable-gl-renderer"
	fi

	if use xembed || use player || use nsplugin ; then
		myconf="${myconf} --enable-xembed"
		if ! use xembed ; then
			elog ""
			elog "Use-flags player and nsplugin require the xembed module."
			elog "Activating it automatically..."
			elog "To silence this message, activate use-flag xembed."
			elog ""
		fi
	else
		myconf="${myconf} --disable-xembed"
	fi

	myconf="${myconf} \
		$(use_enable player) \
		$(use_enable nsplugin mozilla-plugin)"

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	if use nsplugin ; then
		# Clean up a bit to do things more the Gentoo way

		mv "${D}/usr/$(get_libdir)/mozilla/plugins" "${D}/usr/$(get_libdir)/${PN}/" || die
		rmdir "${D}/usr/$(get_libdir)/mozilla" || die
		inst_plugin "/usr/$(get_libdir)/${PN}/plugins/openvrml.so" || die
	fi

	dodoc AUTHORS ChangeLog NEWS README THANKS || die
}
