# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/_rc/-RC}"

DESCRIPTION="Cisco 7200/3600 Simulator"
HOMEPAGE="http://www.ipflow.utc.fr/index.php/Cisco_7200_Simulator"
SRC_URI="http://www.ipflow.utc.fr/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=net-libs/libpcap-0.9.4
	dev-libs/elfutils"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-parallel_build.patch"

	if use amd64; then
		sed -i \
			-e 's:DYNAMIPS_ARCH?=x86:DYNAMIPS_ARCH?=amd64:g' \
			Makefile || die "sed failed"
	fi
}

src_install () {
	dobin dynamips nvram_export \
		|| die "Installing binaries failed"
	doman dynamips.1 hypervisor_mode.7 nvram_export.1 \
		|| die "Installing man pages failed"
	dodoc ChangeLog TODO README README.hypervisor \
		|| die "Installing docs failed"
}

