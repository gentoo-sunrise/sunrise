# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Simple packet logger & soft tap"
HOMEPAGE="http://www.snort.org/users/roesch/Site/Daemonlogger/Daemonlogger.html"
SRC_URI="http://www.snort.org/dl/${PN}/${P}.tar.gz
	http://www.snort.org/users/roesch/code/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libdnet
	net-libs/libpcap"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup daemonlogger
	enewuser daemonlogger -1 -1 -1 daemonlogger
}

src_install() {
	dosbin daemonlogger
	dodoc AUTHORS ChangeLog NEWS README

	keepdir /var/log/daemonlogger

	newinitd "${FILESDIR}"/daemonlogger-initd daemonlogger
	newconfd "${FILESDIR}"/daemonlogger-confd daemonlogger

	fowners daemonlogger:daemonlogger /var/log/daemonlogger
	fperms 0700 /var/log/daemonlogger
}
