# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Protects computers from SSH brute force attacks by dynamically blocking IP addresses over iptables"
HOMEPAGE="http://sourceforge.net/projects/blocksshd/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/perl-Sys-Syslog-0.16
	>=dev-perl/Sys-Hostname-Long-1.2
	>=dev-perl/File-Tail-0.99.1
	>=dev-perl/Net-DNS-0.53-r1
	>=dev-perl/Net-Subnets-0.21
	>=virtual/perl-Getopt-Long-2.34
	>=net-firewall/iptables-1.3.5-r1"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# convert CRLF to LF
	edos2unix blocksshd blocksshd.conf

	#apply patches
	epatch "${FILESDIR}"/${P}.conf-dir-change.patch
	epatch "${FILESDIR}"/${P}.etc-dir-change.patch
}

src_install() {
	dosbin blocksshd || die "dosbin failed"
	dodoc CHANGELOG CREDITS README VERSION blocksshd.conf

	newinitd "${FILESDIR}"/blocksshd.init blocksshd

	insinto /etc/blocksshd
	newins blocksshd.conf blocksshd.conf.sample
}

pkg_postinst() {
	ewarn
	ewarn "The configuration file ${ROOT}etc/blocksshd/blocksshd.conf.sample"
	ewarn "must be renamed before blocksshd will run."
	ewarn "Please review this configuration file for settings that might"
	ewarn "be appropiate for your setup."
	ewarn
}
