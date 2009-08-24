# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="Library to connect to the Nintendo Wii remote"
HOMEPAGE="http://libwiimote.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples force tilt"

RDEPEND="net-wireless/bluez-libs
	net-wireless/bluez-utils"
DEPEND=${RDEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-{amd64,as-needed,include}.patch
	use "tilt" || sed -i -e "s:-D_ENABLE_TILT::" config.mk.in
	use "force" || sed -i -e "s:-D_ENABLE_FORCE::" config.mk.in
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO || die "dodoc failed"

	if use examples; then
		docinto examples
		dodoc test/test?.c || die "dodoc examples failed"
	fi
}
