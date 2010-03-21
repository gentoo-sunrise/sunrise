# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A timer-based entropy generator"
HOMEPAGE="http://www.vanheusden.com/te/"
SRC_URI="http://www.vanheusden.com/te/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	dosbin ${PN} || die "failed to install daemon"
	newinitd "${FILESDIR}/timer_entropyd.initd" ${PN} || die
	dodoc Changes readme.txt || die
}
