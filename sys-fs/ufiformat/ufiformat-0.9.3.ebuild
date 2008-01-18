# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="USB Floppy Disk formatting tool"
HOMEPAGE="http://www.geocities.jp/tedi_world/format_usbfdd_e.html"
SRC_URI="http://www.geocities.jp/tedi_world/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-fs/e2fsprogs"

DEPEND=${RDEPEND}

src_install() {
	dobin ufiformat
	dodoc AUTHORS ChangeLog NEWS README
}
