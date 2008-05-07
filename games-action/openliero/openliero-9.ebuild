# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Almost exact clone of Liero"
HOMEPAGE="http://open.liero.be/"
SRC_URI="http://stepien.cc/~jan/gentoo/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

src_install() {
	dobin openliero || die
}
