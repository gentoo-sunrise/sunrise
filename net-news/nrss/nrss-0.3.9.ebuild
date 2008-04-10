# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Ncurses RSS client"
HOMEPAGE="http://www.codezen.org/nrss/"
SRC_URI="http://ncurses-rss.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-libs/expat
	sys-libs/ncurses"
RDEPEND="${DEPEND}
	net-misc/wget"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"
}
