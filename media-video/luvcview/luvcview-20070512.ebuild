# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit toolchain-funcs

DESCRIPTION="luvcview: Sdl video Usb Video Class grabber"
HOMEPAGE="http://linux-uvc.berlios.de"
SRC_URI="http://mxhaard.free.fr/spca50x/Investigation/uvc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl media-video/mjpegtools"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	sed -e 's/-O2//' -i "${S}"/Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" CPP="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dobin luvcview || die "dobin failed"
	dodoc Changelog README ToDo
}
