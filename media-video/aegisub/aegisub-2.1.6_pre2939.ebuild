# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WX_GTK_VER="2.8"
inherit eutils wxwidgets

MY_P=${P/_pre/-dev-r}

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://www.aegisub.net"
SRC_URI="http://www.mahou.org/~verm/aegisub/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug +ffmpeg lua openal perl pulseaudio spell ruby"

RDEPEND="=x11-libs/wxGTK-2.8*[opengl]
	media-libs/libass
	media-libs/fontconfig
	media-libs/freetype
	virtual/glu

	alsa? (	media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	openal? ( media-libs/openal )
	ffmpeg? ( media-video/ffmpeg )

	perl? ( dev-lang/perl )
	ruby? ( dev-lang/ruby )
	lua? ( dev-lang/lua )

	spell? ( app-text/hunspell )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	media-gfx/imagemagick
	dev-libs/glib
	sys-devel/gettext"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf $(use_with alsa) \
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
