# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Utility for manipulating the scancode/keycode translation tables of keyboard drivers"
HOMEPAGE="http://0pointer.de/lennart/projects/keyfuzz/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( www-client/lynx )"
RDEPEND=""

src_configure() {
	econf $(use_enable doc lynx)
}

src_install() {
	dobin src/${PN}
	dodoc README
	doman man/${PN}.8
}
