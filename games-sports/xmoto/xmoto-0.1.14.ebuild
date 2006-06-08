# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games eutils

HOMEPAGE="http://xmoto.sourceforge.net"
SRC_URI="mirror://sourceforge/xmoto/${P}-src.tar.gz"
DESCRIPTION="X-Moto is a challenging 2D motocross platform game"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""
LICENSE="GPL-2"

RDEPEND="media-libs/jpeg
	media-libs/libpng
	sys-libs/zlib
	media-libs/libsdl
	media-libs/sdl-mixer
	net-misc/curl
	dev-lang/lua
	dev-games/ode
	virtual/opengl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/xmoto-as-needed.patch"
}

src_compile() {
	egamesconf || die "egamesconf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc ChangeLog README TODO
	prepgamesdirs
}
