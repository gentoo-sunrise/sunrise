# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Audio and video broadcast manager"
HOMEPAGE="http://www.somasuite.org/"
SRC_URI="http://www.somasuite.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg"

DEPEND="
	dev-libs/openssl
	>=sys-libs/ncurses-5.0
	>=sys-libs/readline-5.0
	dev-libs/libxml2
	ffmpeg? ( media-video/ffmpeg )"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-pid.patch
}

src_configure() {
	econf \
		$(use_enable ffmpeg)
}

pkg_postinst() {
	einfo " *** *** ***"
	einfo "If you can afford to donate us some money let us know, we also need"
	einfo "new and old working hardware."
	einfo " "
	einfo "you can send a mail to"
	einfo " "
	einfo " mail: soma@inventati.org"
	einfo "  or: bakunin@autistici.org"
	einfo " *** *** ***"
}
