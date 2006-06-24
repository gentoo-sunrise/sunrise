# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${P/_/-}
S="${WORKDIR}/ttcut"

IUSE=""

DESCRIPTION="TTCut is a tool for cutting MPEG especially for removing adds fom tv-recordings"
HOMEPAGE="http://ttcut.tritime.org/"
SRC_URI="http://download.berlios.de/ttcut/${MY_P}.tar.gz"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-libs/libmpeg2-0.4.0
	>=x11-libs/qt-4.1.0"

RDEPEND="${_DEPEND}
	media-video/mplayer
	media-video/dvdauthor
	media-video/transcode
	media-video/ffmpeg"

src_compile() {
	qmake ttcut.pro -o Makefile.ttcut
	make -f Makefile.ttcut
	qmake ttmpeg2.pro -o Makefile.ttmpeg2
	make -f Makefile.ttmpeg2
}

src_install() {
	dobin ttcut
	dobin ttmpeg2
	make_desktop_entry ttcut Ttcut "" AudioVideoEditing
	make_desktop_entry ttmpeg2 Ttmpeg2 "" AudioVideoEditing
}




