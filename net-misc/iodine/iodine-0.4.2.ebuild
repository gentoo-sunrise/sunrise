# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info

DESCRIPTION="IP over DNS tunnel"
HOMEPAGE="http://code.kryo.se/iodine/"
SRC_URI="http://code.kryo.se/iodine/${P}.tar.gz"

CONFIG_CHECK="TUN"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE="test"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

src_install() {
	dobin bin/iodine bin/iodined
	dodoc README CHANGELOG
	doman man/iodine.8

	newinitd "${FILESDIR}"/iodined.init iodined
	newconfd "${FILESDIR}"/iodined.conf iodined
	keepdir /var/empty
}
