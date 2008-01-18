# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="add and remove scsi devices on the fly"
HOMEPAGE="http://llg.cubic.org/tools/"
SRC_URI="http://llg.cubic.org/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_compile() {
	econf $(use_with debug) || die "configure failed!"
	emake || die "make failed"
}

src_install() {
	dosbin scsiadd
}
