# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion linux-info

ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"
ESVN_PROJECT="${PN}"
ESVN_PATCHES=( "${P}-makefile.patch" )

DESCRIPTION="Blocks connections from/to hosts listed in files using iptables."
HOMEPAGE="http://iplist.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RDEPEND="net-firewall/iptables
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	sys-libs/zlib"
DEPEND="${RDEPEND}"
CONFIG_CHECK="NETFILTER_XT_MATCH_IPRANGE"

src_install() {
	emake DESTDIR="${D}" install || die "install failed!"
	doman {${PN},ipblock}.8 || die "doman failed!"
}
