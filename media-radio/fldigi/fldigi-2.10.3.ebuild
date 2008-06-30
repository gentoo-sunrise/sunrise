# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Sound card based multimode software modem for Amateur Radio use."
HOMEPAGE="http://www.w1hkj.com/Fldigi.html"
SRC_URI="http://www.w1hkj.com/fldigi-distro/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="hamlib portaudio pulseaudio sndfile"

RDEPEND=">=x11-libs/fltk-1.1.7
	dev-libs/libxml2
	media-libs/libsamplerate
	media-libs/jpeg
	media-libs/libpng
	hamlib? ( media-libs/hamlib )
	portaudio? ( >=media-libs/portaudio-19_pre20071207 )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( >=media-libs/libsndfile-1.0.10 ) "
DEPEND="${RDEPEND}
	dev-util/pkgconfig"


src_compile() {
	econf $(use_with sndfile) \
	    $(use_with portaudio) \
	    $(use_with hamlib) \
	    $(use_with pulseaudio)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
}
