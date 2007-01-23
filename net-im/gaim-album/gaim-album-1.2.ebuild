# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Archive all your buddies's icons."
HOMEPAGE="http://gaim-album.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT=0
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4
	net-im/gaim"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/gaim-album-1.1-all-users-install.patch"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc COPYRIGHT ChangeLog README TODO
}
