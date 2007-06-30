# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A small and simple personal WikiWikiWeb implementation written in C."
HOMEPAGE="http://didiwiki.org/"
SRC_URI="http://didiwiki.org/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog AUTHORS TODO
}

pkg_postinst() {
	elog "If upgrading from an earlier version, it is a good idea to delete"
	elog "~/.didiwiki/DidiHelp before running DidiWiki to get the latest version"
	elog "of the help file."
}
