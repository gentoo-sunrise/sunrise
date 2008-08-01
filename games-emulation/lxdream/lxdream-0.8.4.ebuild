# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit games

DESCRIPTION="An emulator for the Sega Dreamcast system"
HOMEPAGE="http://lxdream.org/"
SRC_URI="http://${PN}.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug esd pulseaudio"

RDEPEND="media-libs/alsa-lib
	media-libs/libpng
	esd? ( media-sound/esound )
	pulseaudio? ( media-sound/pulseaudio )
	virtual/opengl
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_compile() {
	econf \
		$(use_enable debug trace) \
		$(use_enable debug watch) \
		$(use_with esd) \
		$(use_with pulseaudio pulse) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc RELEASE_NOTES STATUS || die "dodoc failed"
	newicon pixmaps/dcemu.gif ${PN}.gif
	make_desktop_entry ${PN} ${PN/l/L} ${PN} || die "make_desktop_entry failed"
	prepgamesdirs
}
