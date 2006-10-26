# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Visualizes the fragmentation status of ext2/3 filesystems"
HOMEPAGE="http://davl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-fs/e2fsprogs-1.38
	>=x11-libs/gtk+-2.6"
RDEPEND="${DEPEND}"

src_install() {
	dobin src/cdavl/cdavl src/gdavl/gdavl
	dodoc README
	doman doc/*.8
}
