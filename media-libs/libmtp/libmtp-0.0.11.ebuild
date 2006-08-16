# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library for MTP/PlaysForSure media players"
HOMEPAGE="http://libmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=dev-libs/libusb-0.1.7"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/udev-permissions.patch
}

src_compile() {
	econf --enable-hotplugging || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"

	dodoc ChangeLog README
	insinto /etc/udev/rules.d
	newins libmtp.rules 65-mtp.rules
}
