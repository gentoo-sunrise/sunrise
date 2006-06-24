# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

MY_P="Democracy-${PV}"
DESCRIPTION="Democracy is a free and open internet TV platform."
HOMEPAGE="http://www.getdemocracy.com"
SRC_URI="ftp://ftp.osuosl.org/pub/pculture.org/democracy/src/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64" 
#currently the support for firefox appears to be broken
#IUSE="gecko-sdk mozilla firefox"

RDEPEND="dev-python/pyrex
		>virtual/python-2.4
		media-libs/xine-lib
		dev-libs/boost
		>=dev-python/pygtk-2.0
		dev-python/gnome-python-extras
		net-libs/gecko-sdk
		|| ( x11-libs/libX11 virtual/x11 )"
		#www-client/mozilla, maybe even www-client/mozilla-firefox?
		#this are pull by gnome-python
		#gnome-base/gconf
		#gnome-base/gnome-vfs

#TODO  gnome2_src_configure ${G2CONF}
# maybe add support in this way
#/usr/portage/dev-python/gnome-python-extras/gnome-python-extras-2.14.0.ebuild 


DEPEND="${RDEPEND}
		dev-util/pkgconfig"

DOCS="README"

S="${WORKDIR}/${MY_P}/platform/gtk-x11/"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/democracy-{use-gecko-sdk,as-needed-libX11}.patch
}

pkg_postinst(){
	if ! built_with_use -a xine-lib aac ffmpeg mad asf flac sdl win32codecs; then 
		ewarn "The Democracy team recommends you to emerge xine-lib as follows:"
		ewarn ""
		ewarn "# echo \"media-libs/xine-lib aac ffmpeg mad asf flac sdl win32codecs\" \ "
		ewarn ">> /etc/portage/package.use && emerge xine-lib"
		ewarn ""
		ewarn "This way you will have support enabled for the most popular"
		ewarn "video and audio formats. You may also want to add support"
		ewarn "for theora and vorbis"
	fi
}
