# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

MY_PN="rt2x00-git"
DESCRIPTION="EEPROM reader routines for 93cx6 chipsets."
HOMEPAGE="http://rt2x00.serialmonkey.com/"
SRC_URI="http://dev.gentooexperimental.org/~jakub/distfiles/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/drivers/misc"

BUILD_PARAMS="CONFIG_EEPROM_93CX6=m -C ${KV_DIR} M=${S}"
BUILD_TARGETS="modules"
MODULE_NAMES="eeprom_93cx6()"

src_unpack() {
	unpack ${A}
	echo "CFLAGS += -I"${WORKDIR}"/include" >> "${S}"/Makefile
}

src_install() {
	linux-mod_src_install
	dodir /usr/include/eeprom_93cx6/linux/
	insinto /usr/include/eeprom_93cx6/linux/
	doins "${WORKDIR}"/include/linux/eeprom_93cx6.h
}
