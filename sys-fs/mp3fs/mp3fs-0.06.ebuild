# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="FUSE based filesystem which transcodes FLAC files to MP3 on the fly"
HOMEPAGE="http://mp3fs.sourceforge.net/"
SRC_URI="mirror://sourceforge/mp3fs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-sound/lame
	media-libs/flac
	media-libs/libogg
	sys-fs/fuse
	media-libs/libid3tag"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc NEWS README
}
