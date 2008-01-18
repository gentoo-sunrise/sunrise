# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

MY_PN="rt2x00-git"
DESCRIPTION="CRC ITU-T V.41 calculations"
HOMEPAGE="http://rt2x00.serialmonkey.com/"
SRC_URI="http://dev.gentooexperimental.org/~jakub/distfiles/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/lib"

BUILD_PARAMS="CONFIG_CRC_ITU_T=m -C ${KERNEL_DIR} M=${S}"
BUILD_TARGETS="modules"
MODULE_NAMES="crc-itu-t()"

pkg_setup() {
	if kernel_is ge 2 6 22 ; then
		CONFIG_CHECK="${CONFIG_CHECK} !CRC_ITU_T"
		ERROR_CRC_ITU_T="CRC_ITU_T support already enabled in kernel. You do not need this ebuild."
	fi

	linux-mod_pkg_setup
}

src_unpack() {
	unpack ${A}
	echo 'obj-$(CONFIG_CRC_ITU_T) += crc-itu-t.o' > "${S}"/Makefile
	echo "CFLAGS += -I"${WORKDIR}"/include" >> "${S}"/Makefile
}

src_install() {
	linux-mod_src_install
	dodir /usr/include/crc-itu-t/linux/
	insinto /usr/include/crc-itu-t/linux/
	doins "${WORKDIR}"/include/linux/crc-itu-t.h
}
