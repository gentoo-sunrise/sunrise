# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Implements the Host (PC) side of the USB DFU (Universal Serial Bus Device Firmware Upgrade) protocol."
HOMEPAGE="http://wiki.openmoko.org/wiki/Dfu-util/"
ESVN_REPO_URI="http://svn.openmoko.org/trunk/src/host/dfu-util/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libusb"
RDEPEND="${DEPEND}"

src_compile() {
  eautoreconf || die "eautoreconf failed"
  econf prefix=/usr || die "Configure failed"
  emake || die "Make failed"
}

src_install() {
  emake DESTDIR="${D}" install || die "Make install failed"
  dodoc COPYING
}
