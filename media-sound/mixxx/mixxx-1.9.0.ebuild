# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="A QT based Digital DJ tool"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="http://downloads.mixxx.org/${P}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mp4 pulseaudio shout"

RDEPEND="media-libs/flac
	media-libs/libid3tag
	media-libs/libmad
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libsndfile
	>=media-libs/libsoundtouch-1.5
	>=media-libs/portaudio-19_pre
	media-libs/portmidi
	media-libs/taglib
	virtual/opengl
	virtual/glu
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	x11-libs/qt-opengl:4
	x11-libs/qt-qt3support:4
	x11-libs/qt-webkit:4
	x11-libs/qt-xmlpatterns:4
	mp4? (	media-libs/faad2
		media-libs/libmp4v2
	)
	pulseaudio? ( media-sound/pulseaudio )
	shout? ( media-libs/libshout )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

SCONS_MIN_VERSION="2.0.1"

src_unpack() {
	unpack ${A}

	#Fix the src dir
	mv * "${S}" || die
}

src_prepare() {
	# patch CFLAGS issue
	epatch "${FILESDIR}"/${P}-flags.patch

	# patch external libsoundtouch
	epatch "${FILESDIR}"/${P}-libsoundtouch.patch

	# Patch startup command if not using pulse audio
	use pulseaudio || sed -i -e 's:pasuspender ::' src/mixxx.desktop || die
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="/usr/$(get_libdir)" escons \
		prefix=/usr \
		qtdir=/usr/$(get_libdir)/qt4 \
		$(use_scons debug qdebug) \
		$(use_scons mp4 m4a) \
		$(use_scons shout shoutcast) \
		hifieq=1 \
		vinylcontrol=1 \
		optimize=0 \
		|| die
}

src_install() {
	escons install \
		prefix=/usr \
		install_root="${D}"/usr \
		|| die
}
