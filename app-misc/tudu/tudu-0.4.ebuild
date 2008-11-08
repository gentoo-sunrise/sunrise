# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Command line interface to manage hierarchical todos"
HOMEPAGE="http://www.cauterized.net/~meskio/tudu/"
SRC_URI="http://cauterized.net/~meskio/tudu/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"

src_compile() {
	emake DESTDIR="/usr/" ETC_DIR="/etc" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}/usr/" ETC_DIR="${D}/etc" install || die "install failed"
	dodoc AUTHORS README ChangeLog || die
}
