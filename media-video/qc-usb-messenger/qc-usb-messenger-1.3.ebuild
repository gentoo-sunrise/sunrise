# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod eutils

DESCRIPTION="Logitech USB Quickcam Express Messenger & Communicate Linux Driver Modules"
HOMEPAGE="http://home.mag.cx/messenger/"
SRC_URI="http://home.mag.cx/messenger/source/${P}.tar.gz"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="virtual/linux-sources
	!media-video/qc-usb"

src_compile() {
	emake LINUX_DIR=${KERNEL_DIR} all || die "building of quickcam kernel module failed."
}

src_install() {
	insinto /lib/modules/${KV}/drivers/usb
	doins quickcam.${KV_OBJ}
	dobin qcset
	dodoc README* APPLICATIONS CREDITS TODO FAQ _CHANGES_MESSENGER _README_MESSENGER
}
