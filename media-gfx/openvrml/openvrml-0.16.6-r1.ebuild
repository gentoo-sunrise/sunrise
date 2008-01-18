# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="examples imagetexture javascript jpeg nsplugin opengl png truetype zlib" # java

DESCRIPTION="VRML97 library"
SRC_URI="mirror://sourceforge/openvrml/${P}.tar.gz"
HOMEPAGE="http://openvrml.org"

SLOT="0"
LICENSE="BSD GPL-2 LGPL-2.1 public-domain"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/glib-2.6
	gnome-base/libglade
	gnome-base/libgnomeui
	>=gnome-base/libgnome-2.14.1
	net-misc/curl
	examples? ( media-libs/libsdl )
	javascript? ( www-client/mozilla-firefox )
	jpeg? ( media-libs/jpeg )
	nsplugin? ( www-client/mozilla-firefox )
	opengl? ( virtual/opengl virtual/glut )
	png? ( media-libs/libpng sys-libs/zlib )
	truetype? ( >=media-libs/freetype-2 media-libs/fontconfig )"
	# java? ( virtual/jre )

DEPEND="${RDEPEND}
	dev-libs/boost
	app-doc/doxygen"
	# java? ( virtual/jdk dev-java/antlr )

# TODO: add support for java via libmozjs (http://www.mozilla.org/js/spidermonkey/)

pkg_setup() {
	ewarn "Java is currently unsupported in this version!"
	ewarn "Building openvrml with --disable-script-node-java."
}

src_compile() {
	local myconf="--with-x \
		    $(use_enable examples) \
		    $(use_enable javascript script-node-javascript) \
		    $(use_enable jpeg jpeg-textures) \
		    $(use_enable nsplugin mozilla-plugin) \
		    $(use_enable opengl gl-renderer) \
		    $(use_enable png png-textures) \
		    $(use_enable truetype render-text-node) \
		    $(use_enable zlib gzip) \
		    --disable-script-node-java"
		    # Java is currently unsupported
		    # $(use_enable java script-node-java)
		    # use java && myconf="${myconf} --with-jdk=`java-config -O`"

	econf --prefix=/usr ${myconf}
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS
}
