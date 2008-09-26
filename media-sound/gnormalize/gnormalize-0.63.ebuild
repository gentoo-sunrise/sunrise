# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Audio converter/ripper featuring normalization and metadata editing"
HOMEPAGE="http://gnormalize.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac cddb flac mp3 musepack normalize vorbis"

RDEPEND=">=x11-libs/gtk+-2.4.0
	>=dev-perl/gtk2-perl-1.040
	aac? ( media-libs/faac
		media-libs/faad2 )
	cddb? ( dev-perl/CDDB_get
		media-sound/cdcd
		|| ( media-sound/cdparanoia
			virtual/cdrtools ) )
	flac? ( media-libs/flac
		!vorbis? ( media-sound/flac123 ) )
	mp3? ( media-sound/lame
		dev-perl/MP3-Info
		|| ( media-sound/madplay
			media-sound/mpg321
			media-sound/mpg123 ) )
	musepack? ( media-sound/musepack-tools )
	normalize? ( media-sound/wavegain )
	vorbis? ( media-sound/vorbis-tools )"

DEPEND="${RDEPEND} app-arch/lzma-utils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./${PN}.1.lzma
}

src_install() {
	dobin ${PN} || die "dobin failed"

	insinto /usr/share/${PN}
	doins -r animations

	doicon icons/${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}.png "AudioVideo;Audio;AudioVideoEditing"

	doman ${PN}.1
	dodoc README
}

pkg_postinst() {
	einfo "This package supports MAC (Monkey's Audio Codec) but due to licensing"
	einfo "issues MAC cannot be included in Portage at this time. If you need MAC"
	einfo "functionality, build and install the packages 'mac' and 'xmms-mac' from:"
	einfo
	einfo "    http://sourceforge.net/project/showfiles.php?group_id=123827"
	einfo
}
