# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Biogrep matchs large sets of patterns against biosequence dbs and is optimized for multithreading."
HOMEPAGE="http://web.mit.edu/bamel/biogrep.shtml"
SRC_URI="http://web.mit.edu/bamel/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	emake prefix="${D}"/usr install || die "install failed"
}
