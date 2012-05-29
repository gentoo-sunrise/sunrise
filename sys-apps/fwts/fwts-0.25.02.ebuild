# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools
DESCRIPTION="Firmware Test Suite"
HOMEPAGE="https://wiki.ubuntu.com/Kernel/Reference/fwts"
SRC_URI="http://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-apps/pciutils
	sys-power/iasl
	sys-power/pmtools
	sys-apps/dmidecode"
DEPEND="${RDEPEND}
	dev-libs/json-c
	sys-devel/libtool"

src_prepare(){
	sed -i -e 's/-Wall -Werror/-Wall/' configure.ac {,src/,src/lib/src/}Makefile.am || die
	sed -i -e 's:/usr/bin/lspci:/usr/sbin/lspci:' src/lib/include/fwts_binpaths.h || die
	# No Makefile included - upstream wants autoreconf
	eautoreconf
}
