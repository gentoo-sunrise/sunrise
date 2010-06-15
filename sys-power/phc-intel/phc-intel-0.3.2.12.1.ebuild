# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit linux-info linux-mod versionator

DESCRIPTION="Processor Hardware Control for Intel CPUs"
HOMEPAGE="http://www.linux-phc.org/"
SRC_URI="http://www.linux-phc.org/forum/download/file.php?id=94 -> ${P}.tar.bz2
	http://xmw.de/mirror/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-$(replace_version_separator 3 '-' $(replace_version_separator 4 '-'))

CONFIG_CHECK="~!X86_ACPI_CPUFREQ"
ERROR_X86_ACPI_CPUFREQ="CONFIG_X86_ACPI_CPUFREQ has to be configured to Module or Not set to enable the replacement of acpi-cpufreq with phc-intel."

MODULE_NAMES="phc-intel(misc:)"
BUILD_PARAMS="KERNELSRC=\"${KERNEL_DIR}\" -j1"
BUILD_TARGETS="all"

pkg_setup() {
	if kernel_is lt 2 6 33 ; then
		eerror "Your kernel version is no longer supported by this version of ${PN}."
		eerror "Please use a previous version of ${PN} or a newer kernel."
		die
	fi
	linux-mod_pkg_setup
}

src_install() {
	linux-mod_src_install
	dodoc README || die
}
