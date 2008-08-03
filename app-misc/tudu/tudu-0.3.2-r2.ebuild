# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Command line interface to manage hierarchical todos"
HOMEPAGE="http://www.cauterized.net/~meskio/tudu/"
SRC_URI="http://cauterized.net/~meskio/tudu/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses"

src_compile() {
	emake DESTDIR="${ROOT}usr/" ETC_DIR="${ROOT}etc" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}/usr/" install || die "install failed"
	# Cleanup for Makefile bug, since it never creates ETC_DIR beforehand:
	rm -f "${D}usr/etc"
	insinto "${ROOT}etc"
	doins data/tudurc || die
	dodoc README ChangeLog || die
}
