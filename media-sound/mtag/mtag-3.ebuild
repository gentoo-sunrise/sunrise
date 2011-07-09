# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils eutils

DESCRIPTION="Fast media tag lib"
HOMEPAGE="http://mtag.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="media-libs/taglib
	dev-db/sqlite:3"
DEPEND="${RDEPEND}"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc46.patch
}

src_install() {
	dobin ${PN}
	dodoc AUTHORS ChangeLog README
	if use doc; then
		dohtml -r html/*
	fi
}
