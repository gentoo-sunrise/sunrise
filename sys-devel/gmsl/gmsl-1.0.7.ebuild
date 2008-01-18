# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GNU Make Standard Library"
HOMEPAGE="http://gmsl.sourceforge.net/"
SRC_URI="mirror://sourceforge/gmsl/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	insinto /usr/include
	doins __gmsl
	doins gmsl
	doins gmsl-tests
	dodoc README
}
