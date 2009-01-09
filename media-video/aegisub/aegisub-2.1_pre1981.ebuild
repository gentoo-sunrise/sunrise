# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WX_GTK_VER="2.8"
inherit eutils wxwidgets

MY_PV="${PV/_pre/-dev-r}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://malakith.net/aegiwiki/Main_Page"
SRC_URI="http://www.mahou.org/~verm/aegisub/archives/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug +ffmpeg lua openal perl pulseaudio spell ruby"

RDEPEND="=x11-libs/wxGTK-2.8*[opengl]
	media-libs/libass
	media-libs/fontconfig
	media-libs/freetype

	alsa? (	media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	openal? ( media-libs/openal )

	perl? ( dev-lang/perl )
	ruby? ( dev-lang/ruby )
	lua? ( dev-lang/lua )

	spell? ( app-text/hunspell )
	ffmpeg? ( media-video/ffmpeg )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	media-gfx/imagemagick
	dev-libs/glib"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf --with-libass \
	$(use_with alsa) \
	--without-portaudio \
	$(use_with pulseaudio) \
	$(use_with openal) \
	$(use_with lua) \
	$(use_with ruby) \
	$(use_with perl) \
	$(use_with ffmpeg) \
	$(use_with spell hunspell) \
	$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon "${FILESDIR}"/${PN}.png
	make_desktop_entry "${PN}" "Aegisub" "${PN}" "AudioVideo;Video;"
}
