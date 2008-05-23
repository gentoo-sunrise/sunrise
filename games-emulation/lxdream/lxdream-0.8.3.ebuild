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
IUSE=""

RDEPEND="media-libs/libpng
	media-sound/esound
	virtual/opengl
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc RELEASE_NOTES STATUS
	newicon pixmaps/dcemu.gif lxdream.gif
	make_desktop_entry lxdream Lxdream lxdream || die "make_desktop_entry failed"
	prepgamesdirs
}
