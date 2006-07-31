# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The dnsproxy daemon is a proxy for DNS queries"
HOMEPAGE="http://www.wolfermann.org/dnsproxy.html"
SRC_URI="http://www.wolfermann.org/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-libs/libevent"
DEPEND="${RDEPEND}"

src_compile() {
	econf --with-native-libevent || die "econf failed"
	make dnsproxy || die "make failed"
}

src_install() {
	dosbin dnsproxy
	dodoc README
	doman dnsproxy.1
	insinto /etc/dnsproxy
	newins dnsproxy.conf dnsproxy.conf-dist
	newconfd "${FILESDIR}"/confd dnsproxy
	newinitd "${FILESDIR}"/initd dnsproxy
}
