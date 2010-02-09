# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

DESCRIPTION="the fast media tag lib"
HOMEPAGE="http://mtag.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="media-libs/taglib
	>=dev-db/sqlite-3.3.12"
DEPEND="${RDEPEND}"

CMAKE_IN_SOURCE_BUILD=1

src_install() {
	dobin mtag || die "dobin failed"
	dodoc README ChangeLog AUTHORS || die "dodoc failed"
	if use doc; then
		dohtml -r html/* || die "dohtml failed"
	fi
}
