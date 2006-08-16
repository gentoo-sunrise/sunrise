# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="libmtp is a C library and API for communicating with MTP/PlaysForSure media players under BSD and Linux."
HOMEPAGE="http://libmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/libmtp/${P}.tar.gz"
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
	econf --enable-hotplugging
	emake -j1
}

src_install() {
	emake DESTDIR=${D} install

	dodoc ChangeLog README
	insinto /etc/udev/rules.d
	newins libmtp.rules 65-mtp.rules
}
