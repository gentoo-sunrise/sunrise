# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A simple and lightweight JavaScript minifier"
HOMEPAGE="http://crockford.com/javascript/jsmin.html"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

src_compile() {
	emake ${PN} || die
}

src_install() {
	dobin ${PN} || die
}
