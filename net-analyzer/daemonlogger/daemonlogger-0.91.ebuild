# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Simple packet logger & soft tap"
HOMEPAGE="http://www.snort.org/users/roesch/Site/Daemonlogger.html"
SRC_URI="http://www.snort.org/dl/${PN}/${P}.tar.gz
	http://www.snort.org/users/roesch/code/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libdnet
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_install() {
	dosbin daemonlogger
	dodoc AUTHORS ChangeLog NEWS README
}
