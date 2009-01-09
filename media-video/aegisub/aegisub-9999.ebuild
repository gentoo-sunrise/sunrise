# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WX_GTK_VER="2.8"
inherit eutils subversion wxwidgets

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://malakith.net/aegiwiki/Main_Page"
SRC_URI=""

ESVN_REPO_URI="https://spaceboyz.net/svn/${PN}/trunk/"

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

src_configure() {
	# The provided autogen script executes configure too
	# I'm using it instead of autotools because it also converts
	# some image files and do some other stuff.
	./autogen.sh --with-libass \
		$(use_with alsa) \
		--without-portaudio \
		$(use_with pulseaudio) \
		$(use_with openal) \
		$(use_with lua) \
		$(use_with ruby) \
		$(use_with perl) \
		$(use_with ffmpeg) \
		$(use_with spell hunspell) \
		$(use_enable debug) || die "autogen failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon "${FILESDIR}"/${PN}.png
	make_desktop_entry "${PN}" "Aegisub" "${PN}" "AudioVideo;Video;"
}
