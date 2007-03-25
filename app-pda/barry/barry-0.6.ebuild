# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Barry is an Open Source Linux application that will allow synchronization, backup, restore and program management for BlackBerry devices"
HOMEPAGE="http://www.netdirect.ca/software/packages/barry/"
SRC_URI="mirror://sourceforge/barry/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libusb
	dev-libs/openssl"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS

	#  udev rules
	insinto /etc/udev/rules.d
	newins udev/10-blackberry.rules 10-blackberry.rules
}
