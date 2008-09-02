# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A tool to measure bandwidth and RTT between two hosts using ICMP"
HOMEPAGE="http://tclmon.vsi.ru/utils.php"
SRC_URI="http://tclmon.vsi.ru/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

src_install () {
	dosbin bwping           || die "dosbin failed"
	doman  bwping.8         || die "doman failed"
	dodoc  ChangeLog README || die "dodoc failed"
}
