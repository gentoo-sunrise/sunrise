# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games

DESCRIPTION="An emulator for the Sega Dreamcast system"
HOMEPAGE="http://www.lxdream.org/"
SRC_URI="http://www.lxdream.org/count.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug esd profile pulseaudio sdl"

RDEPEND="media-libs/alsa-lib
	media-libs/libpng
	esd? ( media-sound/esound )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl )
	virtual/opengl
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	virtual/os-headers"

src_configure() {
	econf \
		$(use_enable debug trace) \
		$(use_enable debug watch) \
		$(use_enable profile profiled) \
		$(use_with esd) \
		$(use_with pulseaudio pulse) \
		$(use_with sdl)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog NEWS README || die "dodoc failed"
	doicon pixmaps/${PN}.png || die "doicon failed"
	domenu ${PN}.desktop || die "make_desktop_entry failed"
	prepgamesdirs
}
