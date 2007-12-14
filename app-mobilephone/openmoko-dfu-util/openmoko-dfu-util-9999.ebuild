# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Implements the Host (PC) side of the USB DFU (Universal Serial Bus Device Firmware Upgrade) protocol."
HOMEPAGE="http://wiki.openmoko.org/wiki/Dfu-util/"
ESVN_REPO_URI="http://svn.openmoko.org/trunk/src/host/dfu-util/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/libusb"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
