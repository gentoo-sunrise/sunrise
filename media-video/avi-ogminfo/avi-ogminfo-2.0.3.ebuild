# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A small program for getting information about media files"
HOMEPAGE="http://avi-ogminfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="dev-libs/libxml2
	>=x11-libs/gtk+-2.4
	>=dev-cpp/gtkmm-2.6
	>=media-video/ffmpeg-0.4.9_p20050906
	>=media-libs/libogg-1.1
	>=media-libs/libvorbis-1.0"

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc Changelog README{,.en}
}
