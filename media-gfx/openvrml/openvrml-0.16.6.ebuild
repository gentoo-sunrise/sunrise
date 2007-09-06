# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="imagetexture javascript nsplugin opengl truetype zlib" # java

DESCRIPTION="VRML97 library"
SRC_URI="mirror://sourceforge/openvrml/${P}.tar.gz"
HOMEPAGE="http://openvrml.org"

SLOT="0"
LICENSE="BSD GPL-2 LGPL-2.1 public-domain"
KEYWORDS="~amd64 ~x86"

RDEPEND="gnome-base/libgnomeui
	net-misc/curl
	zlib? ( sys-libs/zlib )
	imagetexture? ( media-libs/libpng media-libs/jpeg )
	truetype? ( media-libs/freetype media-libs/fontconfig )
	javascript? ( www-client/mozilla-firefox )
	nsplugin? ( www-client/mozilla-firefox )
	opengl? ( virtual/opengl virtual/glut )"
	# java? ( virtual/jre )

DEPEND="${RDEPEND}
	dev-libs/boost
	app-doc/doxygen"
	# java? ( virtual/jdk )

# TODO: add support for java via libmozjs (http://www.mozilla.org/js/spidermonkey/)

pkg_setup() {
	ewarn "Java is currently unsupported in this version!"
	ewarn "Building openvrml with --disable-script-node-java."
}

src_compile() {
	local myconf="--with-x \
		    $(use_enable zlib gzip) \
		    $(use_enable imagetexture imagetexture-node) \
		    $(use_enable truetype text-node) \
		    $(use_enable javascript script-node-javascript) \
		    $(use_enable opengl gl-renderer) \
		    $(use_enable opengl lookat) \
		    $(use_enable nsplugin mozilla-plugin) \
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
