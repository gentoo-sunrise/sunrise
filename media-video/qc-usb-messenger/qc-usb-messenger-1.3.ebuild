# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="Logitech USB Quickcam Express Messenger & Communicate Linux Driver Modules"
HOMEPAGE="http://home.mag.cx/messenger/"
SRC_URI="http://home.mag.cx/messenger/source/${P}.tar.gz"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="virtual/linux-sources
	!media-video/qc-usb"

CONFIG_CHECK="USB VIDEO_DEV"
MODULE_NAMES="quickcam(usb:)"
BUILD_TARGETS="all"

pkg_setup() {
	ABI=${KERNEL_ABI}
	linux-mod_pkg_setup
	BUILD_PARAMS="LINUX_DIR=${KV_DIR}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	convert_to_m "${S}/Makefile"
}

src_install() {
	linux-mod_src_install
	dobin qcset
	dodoc README* APPLICATIONS CREDITS TODO FAQ _CHANGES_MESSENGER _README_MESSENGER
	insinto /usr/share/doc/${PF}
	doins quickcam.sh debug.sh freeshm.sh
}
