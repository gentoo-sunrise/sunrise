# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="http://www.djcbsoftware.nl/code/mu/"
SRC_URI="http://mu0.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/gmime
	dev-libs/xapian
	"
RDEPEND="${DEPEND}"

DOCS=( "AUTHORS" "HACKING" "NEWS" "TODO" )

pkg_postinst() {
	elog "Note: the Xapian database is no longer stored as ~/.mu/xapian-0.6"
	elog "but instead simply as ~/.mu/xapian. You can remove the older"
	elog "~/.mu/xapian-0.6 directory to save some disk space"
}
