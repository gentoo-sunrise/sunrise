# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod linux-info

DESCRIPTION="Nvidia-based graphics adapter backlight driver"
HOMEPAGE="https://launchpad.net/~mactel-support"
SRC_URI="https://launchpad.net/~mactel-support/+archive/ppa/+files/${PN}-dkms_${PV}~karmic.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/${PN}-dkms-${PV}.0"

MODULE_NAMES="nvidia_bl(kernel/drivers::${S}/usr/src/dkms_source_tree/)"

pkg_setup() {
	kernel_is -lt 2 6 29 && die "kernel 2.6.29 or higher is required"
	linux-mod_pkg_setup
	BUILD_PARAMS="-C ${KV_DIR} M=${S}/usr/src/dkms_source_tree"
	BUILD_TARGETS="nvidia_bl.ko"
}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/nvidia-bl-makefile.patch"
}
