# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Simple GTK+ Based CD Ripper"
HOMEPAGE="http://ripoffc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 vorbis"

RDEPEND="dev-libs/libcdio
	media-libs/libcddb
	>=x11-libs/gtk+-2.6
	flac? ( media-libs/flac )
	mp3? ( media-sound/lame )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"

src_compile() {
	econf \
		$(use_enable flac) \
		$(use_enable mp3) \
		$(use_enable vorbis) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
}
