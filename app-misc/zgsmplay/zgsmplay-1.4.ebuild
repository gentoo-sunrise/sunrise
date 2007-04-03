# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Curses-based real-time GSM file player with file selector"
HOMEPAGE="http://rus.members.beeb.net/zgsmplay.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/sound/players/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	exeinto /usr/bin
	doexe zgsmplay
	doman zgsmplay.1
	dodoc NEWS README TODO
}
