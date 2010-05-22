# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Image capture application based on unicap"
HOMEPAGE="http://unicap-imaging.org/"
SRC_URI="http://unicap-imaging.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="gnome-base/gconf:2
	gnome-base/libglade:2.0
	media-libs/alsa-lib
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/ucil[alsa,theora]
	media-libs/unicapgtk
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
RDEPEND=${DEPEND}

src_prepare() {
	# workaround for https://bugs.launchpad.net/unicap/+bug/563985
	sed -e 's:<ucview/ucview\.h>:"ucview.h":g' -i src/ucview-window.h
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die
}

pkg_postinst() {
	has_version media-video/ucview_plugins ||
		einfo 'Plugins for UCView are available in media-video/ucview_plugins.'
}
