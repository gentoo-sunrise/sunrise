# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils subversion

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://malakith.net/aegiwiki/Main_Page"
SRC_URI=""

ESVN_REPO_URI="https://spaceboyz.net/svn/aegisub/trunk"
ESVN_PROJECT="https://spaceboyz.net/svn/aegisub"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug ffmpeg lua openal perl portaudio pulseaudio spell ruby"

RDEPEND="=x11-libs/wxGTK-2.8*
	media-libs/libass
	media-libs/fontconfig
	media-libs/freetype

	alsa? (	media-libs/alsa-lib )
	portaudio? ( =media-libs/portaudio-18* )
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

pkg_setup() {
	if ! built_with_use x11-libs/wxGTK opengl; then
		eerror "Aegisub needs wxGTK with opengl support. Please recompile wxGTK:"
		eerror "echo \"x11-libs/wxGTK opengl\" >> /etc/portage/package.use"
		eerror "emerge -av1 wxGTK"
		die "wxGTK not compiled with 'opengl'!"
	fi
}

src_compile() {
	local myconf
	myconf="--with-libass --prefix=/usr"
	# Audio drivers	
	myconf="${myconf}
	$(use_with alsa) \
	$(use_with portaudio) \
	$(use_with pulseaudio) \
	$(use_with openal)"
	# Automation
	myconf="${myconf}
	$(use_with lua) \
	$(use_with ruby) \
	$(use_with perl)"
	# Other stuff
	myconf="${myconf}
	$(use_with ffmpeg) \
	$(use_with spell hunspell)
	$(use_enable debug)"
	# The provided autogen script executes configure too
	# I'm using it instead of autotools because it also converts
	# some image files and do some other stuff.
	./autogen.sh ${myconf} || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon "${FILESDIR}"/${PN}.png
	make_desktop_entry "${PN}" "Aegisub" "${PN}" "AudioVideo;Video;"
}

