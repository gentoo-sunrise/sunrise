# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info eutils

DESCRIPTION="Blocks connections from/to hosts listed in files using iptables."
HOMEPAGE="http://iplist.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-firewall/iptables
		net-libs/libnetfilter_queue
		net-libs/libnfnetlink
		sys-libs/zlib"
DEPEND="${RDEPEND}"
CONFIG_CHECK="NETFILTER_XT_MATCH_IPRANGE"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed!"
	doman {${PN},ipblock}.8 || die "doman failed!"
	exeinto /etc/cron.daily
	newexe debian/ipblock.cron.daily ipblock || die "cron failed"
}
