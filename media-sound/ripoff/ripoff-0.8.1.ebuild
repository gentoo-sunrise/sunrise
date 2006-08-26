# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Simple GTK+ Based CD Ripper"
HOMEPAGE="http://ripoffc.sourceforge.net"
SRC_URI="mirror://sourceforge/ripoffc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vorbis mp3 flac"
RDEPEND=">=x11-libs/gtk+-2.4
	dev-libs/libcdio
	media-libs/libcddb
	vorbis? ( media-libs/libvorbis )
	mp3? ( media-sound/lame )
	flac? ( media-libs/flac )"
DEPEND="${RDEPEND}"

src_compile() {
	econf \
		$(use_enable vorbis) \
		$(use_enable mp3) \
		$(use_enable flac) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
}
