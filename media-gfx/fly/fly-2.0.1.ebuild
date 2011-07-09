# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Creates PNG, JPEG or GIF images from CGI and other programs"
HOMEPAGE="http://martin.gleeson.net/fly/"
SRC_URI="http://martin.gleeson.net/${PN}/dist/${P}.tar.gz"

LICENSE="fly"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="media-libs/freetype
	media-libs/gd[jpeg,png]"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN}

	dodoc doc/* README

	if use examples ; then
		dodoc examples/*
	fi
}
