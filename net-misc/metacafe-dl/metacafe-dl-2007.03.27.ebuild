# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A small command-line program to download videos from metacafe.com."
HOMEPAGE="http://www.arrakis.es/~rggi3/metacafe-dl/"
SRC_URI="http://www.arrakis.es/~rggi3/${PN}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

src_unpack() {
	:
}

src_install() {
	dobin "${DISTDIR}/${P}"
	dosym "${P}" "/usr/bin/${PN}"
}
