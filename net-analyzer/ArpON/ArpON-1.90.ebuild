# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

DESCRIPTION="ArpON (Arp handler inspectiON) is a portable Arp handler."

HOMEPAGE="http://arpon.sourceforge.net/"
SRC_URI="mirror://sourceforge/arpon/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/libdnet
	net-libs/libnet:1.1
	net-libs/libpcap"

RDEPEND=${DEPEND}

src_compile() {
	emake gentoo || die "emake Gentoo failed"
}

src_install() {
	dosbin arpon  || die "arpon installation failed"
	doman man8/arpon.8 || die "arpon man installation failed"
	dodoc AUTHORS  CHANGELOG TODO || die
	dohtml man8/html/*.html doc/*.png || die
}
