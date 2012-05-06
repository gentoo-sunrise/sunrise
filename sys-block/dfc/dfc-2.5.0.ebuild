# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Display file system space usage using graph and colors"
HOMEPAGE="http://projects.gw-computing.net/projects/dfc"
SRC_URI="http://projects.gw-computing.net/attachments/download/42/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

pkg_setup() {
	tc-export CC
}

src_install() {
	emake PREFIX=/usr MANDIR=/usr/share/man DESTDIR="${D}" install
	dodoc README AUTHORS HACKING
}
