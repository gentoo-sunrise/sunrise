# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A console based helper script for managing Gentoo elogs generated during the emerge process"
HOMEPAGE="http://www.mpagano.com/blog/?page_id=29"
SRC_URI="http://www.mpagano.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	dobin ${PN} || die "dobin failed"
	doman *.[0-9]
}
