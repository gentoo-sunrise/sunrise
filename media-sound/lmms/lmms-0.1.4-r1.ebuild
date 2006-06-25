# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"
SRC_URI="mirror://sourceforge/lmms/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

S="${WORKDIR}/${P}"

RESTRICT="strip"

IUSE="alsa flac ladspa vorbis oss sdl samplerate jack debug"
DEPEND=">=x11-libs/qt-3.3.4
	vorbis? ( media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	sdl? ( media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1 )
	samplerate? ( media-libs/libsamplerate )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	flac? ( media-libs/flac )
	ladspa? ( media-libs/ladspa-sdk )"

src_compile() {
	econf \
		$( use_with alsa asound ) \
		$( use_with flac ) \
		$( use_with ladspa ) \
		$( use_with vorbis ) \
		$( use_with samplerate ) \
		$( use_with oss ) \
		$( use_with sdl ) \
		$( use_with sdl sdlsound )\
		$( use_with jack ) \
		$( use_enable debug ) \
		--enable-hqsinc || die "Configure failed"

	emake || die "Make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"

	newicon "artwork/icon.png" ${PN}.png || die "newicon failed"
	make_desktop_entry ${PN} "Linux MultiMedia Studio" ${PN}.png || die "make_desktop_entry failed"
	dodoc README AUTHORS ChangeLog TODO || die "dodoc failed"
}
