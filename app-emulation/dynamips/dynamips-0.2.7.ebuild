# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

DESCRIPTION="dynamips a Cisco 7200/3600 Simulator"
HOMEPAGE="http://www.ipflow.utc.fr/index.php/Cisco_7200_Simulator"
SRC_URI="http://www.ipflow.utc.fr/dynamips/${P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64"
IUSE=""
DEPEND="net-libs/libpcap
	|| ( dev-libs/libelf dev-libs/elfutils )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:PCAP_LIB=\/:#PCAP:g' Makefile || die
	sed -i -e 's:#PCAP_LIB=-lpcap:PCAP_LIB=-lpcap:g' Makefile || die
	if use amd64; then
		sed -i -e 's:DYNAMIPS_ARCH?=x86:DYNAMIPS_ARCH?=amd64:g' Makefile || die
	fi
}

src_compile() {
	emake -j1 || die "emake ${P} failed"
	# fails with -j2 or higher
}

src_install () {
	dobin nvram_export dynamips || die
	doman dynamips.1 hypervisor_mode.7 nvram_export.1
	dodoc ChangeLog TODO README README.hypervisor
}
