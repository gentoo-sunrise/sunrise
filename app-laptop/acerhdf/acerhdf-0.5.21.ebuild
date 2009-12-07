# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

MY_PN=${PN}_kmod
MY_P=${MY_PN}-${PV}

DESCRIPTION="A kernelmodule which monitors the temperature of the aspire one netbook"
HOMEPAGE="http://piie.net/index.php?section=acerhdf"
SRC_URI="http://piie.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/linux-sources-2.6.30"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

BUILD_TARGETS="default"
MODULE_NAMES="${PN}(:${S}:${S})"
MODULESD_ACERHDF_DOCS="README.txt"
BUILD_PARAMS="KDIR=${KERNEL_DIR}"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 30; then
		ewarn "This version of ${PN} needs at least kernel version 2.6.30 selected"
		ewarn "Please set the /usr/src/linux symlink to the right version"
		die "This version of ${PN} needs at least kernel version 2.6.30 selected"
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo "The module now starts with kernel mode off"
	einfo "Add options acerhdf kernelmode=1 to your"
	einfo "/etc/modprobe.d/acerhdf.conf to enable it at loadtime"
}
