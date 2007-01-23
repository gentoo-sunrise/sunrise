# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="A simple backup system for KDE"
HOMEPAGE="http://jr.falleri.free.fr/keep/wiki/Home"
SRC_URI="http://jr.falleri.free.fr/files/devel/keep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-backup/rdiff-backup-1.0.1-r1"

need-kde 3.5.2

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog TODO AUTHORS README VERSION
}

pkg_postinst() {
	ewarn
	ewarn "After initial install the Keep daemon needs to be started "
	ewarn "manually via KControl - Services. The Keep daemon will automatically "
	ewarn "be loaded at the next KDE startup"
	ewarn
	ewarn "For details, please visit the homepage at ${HOMEPAGE}"
	ewarn
}
