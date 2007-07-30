# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info

DESCRIPTION="IP over DNS tunnel"
HOMEPAGE="http://code.kryo.se/iodine/"
SRC_URI="http://code.kryo.se/iodine/${P}.tar.gz"

CONFIG_CHECK="TUN"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ia64"
IUSE=""

DEPEND="sys-libs/zlib
	test? ( dev-libs/check )"
RDEPEND=""

src_install() {
	dobin bin/iodine bin/iodined
	dodoc README CHANGELOG
	doman man/iodine.8
}

