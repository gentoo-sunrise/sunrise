# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-info

DESCRIPTION="Blocks connections from/to hosts listed in files using iptables."
HOMEPAGE="http://iplist.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="java"

DEPEND="net-firewall/iptables
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	sys-libs/zlib"
RDEPEND="java? ( >=virtual/jre-1.5 )
	${DEPEND}"
CONFIG_CHECK="NETFILTER_XT_MATCH_IPRANGE"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-makefile.patch
	epatch "${FILESDIR}"/${P}-init.patch
}

src_install() {
	if use java ; then
		insinto "/usr/share/${PN}"
		doins ipblockUI.jar || die "gui install failed"
	fi
	emake DESTDIR="${D}" install || die "install failed!"
	doman {${PN},ipblock}.8 || die "doman failed!"
	exeinto /etc/cron.daily
	newexe debian/ipblock.cron.daily ipblock || die "cron failed"
}

pkg_postinst() {
	einfo "a cron file was set in /etc/cron.daily"
	einfo "and it will update your lists once a day"
}
