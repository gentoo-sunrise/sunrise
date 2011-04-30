# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Simple GTK+ Based CD Ripper"
HOMEPAGE="http://ripoffc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 vorbis"

RDEPEND="
	dev-libs/libcdio
	media-libs/libcddb
	x11-libs/gtk+:2
	flac? ( media-libs/flac )
	mp3? ( media-sound/lame )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable flac) \
		$(use_enable mp3) \
		$(use_enable vorbis)
}
