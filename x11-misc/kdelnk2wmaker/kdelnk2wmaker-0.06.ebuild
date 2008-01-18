# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Converts .desktop and .kdelnk files to Windowmaker menu format"
HOMEPAGE="http://members.elysium.pl/ytm/html/kdelnk.html"
SRC_URI="http://members.elysium.pl/ytm/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dodoc AUTHORS BUGS README TODO
	dobin ${PN}
}
