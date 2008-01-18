# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="Ricoh R5U870 usb webcam drivers"
HOMEPAGE="http://lsb.blogdns.net/ry5u870/"
SRC_URI="http://lsb.blogdns.net/files/${P}.tgz"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="USB VIDEO_DEV VIDEO_V4L1_COMPAT VIDEO_VIVI"
MODULE_NAMES="r5u870(usb:)"
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KDIR=${KV_DIR}"
}

src_install() {
	linux-mod_src_install

	dodoc README ChangeLog

	insinto /lib/firmware
	doins r5u870_1810.fw r5u870_1830.fw r5u870_1832.fw r5u870_1833.fw r5u870_1834.fw r5u870_1835.fw r5u870_1836.fw r5u870_1870.fw r5u870_1870_1.fw
}
