# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A zip password recovery utility"
HOMEPAGE="http://www.goof.com/pcg/marc/fcrackzip.html"
SRC_URI="http://www.goof.com/pcg/marc/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-arch/unzip"

src_install() {
	dobin fcrackzip || die "dobin failed"
	newbin zipinfo zipinfo-fcrack || die "newbin failed"
	dodoc AUTHORS NEWS README || die "dodoc die"
}
