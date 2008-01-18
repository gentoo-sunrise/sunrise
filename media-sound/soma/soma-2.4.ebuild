# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="ffmpeg"

DESCRIPTION="Audio and video broadcast manager"
HOMEPAGE="http://www.somasuite.org"
SRC_URI="http://www.somasuite.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/openssl
	>=sys-libs/ncurses-5.0
	>=sys-libs/readline-5.0
	dev-libs/libxml2
	ffmpeg? ( media-video/ffmpeg )"

RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-pid.patch
}

src_compile() {
	econf \
		$(use_enable ffmpeg) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README README.module
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
