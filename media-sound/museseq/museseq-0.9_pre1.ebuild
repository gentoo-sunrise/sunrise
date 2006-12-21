# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/museseq/museseq-0.8.1-r1.ebuild,v 1.2 2006/11/25 09:37:37 opfer Exp $ 

inherit kde-functions virtualx eutils
MY_P=${P/museseq/muse}
MY_P=${MY_P/_/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A MIDI/Audio sequencer with recording and editing capabilities using jack/alsa"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.gz"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE="doc lash debug"

DEPEND="$(qt_min_version 3.2)
	>=media-libs/alsa-lib-0.9.0
	media-sound/fluidsynth
	doc? ( app-text/openjade
		app-doc/doxygen
		media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.1
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.98.0
	lash? ( media-sound/lash )"

src_compile() {
	local myconf
	Xeconf --disable-suid-build \
		$(use_enable lash) \
		$(use_enable debug) \
		|| die "configure failed"
	emake all || die
}

src_install() {
	emake DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README SECURITY README.*
	mv ${D}/usr/bin/muse ${D}/usr/bin/museseq
}

pkg_postinst() {
	einfo "You must have the realtime module loaded to use MusE 0.9.x"
	einfo "Realtime LSM: http://sourceforge.net/projects/realtime-lsm/"
	einfo " -> http://www.muse-sequencer.org/wiki/index.php/Realtime"
	einfo ""
	einfo "Additionally, configure your Linux Kernel for non-generic"
	einfo "Real Time Clock support enabled or loaded as a module."
	einfo "User must have read/write access to /dev/misc/rtc device."
	einfo " -> /dev/rtc or /dev/misc/rtc"
}
