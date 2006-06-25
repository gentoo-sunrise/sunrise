# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Tool for removing advertisements from recorded MPEG files"
HOMEPAGE="http://ttcut.tritime.org/"
SRC_URI="http://download.berlios.de/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ttmpeg2"

DEPEND=">=media-libs/libmpeg2-0.4.0
	>=x11-libs/qt-4.1.0"

RDEPEND="${DEPEND}
	media-video/mplayer
	media-video/dvdauthor
	media-video/transcode
	media-video/ffmpeg"

S=${WORKDIR}/${PN}

src_compile() {
	if use ttmpeg2 ; then
		qmake ttmpeg2.pro -o Makefile.ttmpeg2
		make -f Makefile.ttmpeg2
	fi

	qmake ttcut.pro -o Makefile.ttcut
	make -f Makefile.ttcut
}

src_install() {
	if use ttmpeg2 ; then
		dobin ttmpeg2
		make_desktop_entry ttmpeg2 Ttmpeg2 "" AudioVideoEditing
	fi

	dobin ttcut
	make_desktop_entry ttcut Ttcut "" AudioVideoEditing
}
