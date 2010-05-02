# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
MY_PV="${PV/.0}"

DESCRIPTION="Intel (R) WiMAX 5150/5350 Firmware"
HOMEPAGE="http://www.linuxwimax.org"
SRC_URI="http://www.linuxwimax.org/Download?action=AttachFile&do=get&target=${P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_install() {
	insinto /lib/firmware
	doins "${S}/${PN}-usb-${MY_PV}.sbcf" || die

	dodoc README || die
}
