# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

KEYWORDS="~x86"

MY_P=${P/mob/MoB}

DESCRIPTION="A linux console application that blocks connections from/to hosts listed in a file in peerguardian format using iptables."
HOMEPAGE="http://moblock.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${MY_P}-i586.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=net-firewall/libnetfilter_queue-0.0.11
		>=net-firewall/libnfnetlink-0.0.14"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dosbin moblock
	newconfd "${FILESDIR}/confd" moblock
	newinitd "${FILESDIR}/initd" moblock
	dodir /etc/moblock
	touch "${D}/etc/moblock/p2p.p2b"
	dodir /var/log
	touch "${D}/var/log/moblock.log"
	dodoc Changelog README
}
