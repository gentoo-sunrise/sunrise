# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils linux-info linux-mod rpm

DESCRIPTION="GPL Linux MIDI drivers for Hercules DJ midi controller devices"
HOMEPAGE="http://ts.hercules.com/eng/index.php?pg=view_files&gid=2&fid=28&pid=215&cid=1"
MY_PN="Hercules_DJSeries_Linux"

SRC_URI="ftp://ftp.hercules.com/pub/webupdate/DJCSeries/${MY_PN}.tgz -> ${P}.tgz
	http://ompldr.org/vOG1vbg/${PN}-kernel_2.6.35_fix.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BUILD_TARGETS="clean modules"
MODULE_NAMES="hdj_mod()"

pkg_setup () {
	BUILD_PARAMS="KERN_DIR=\"${KV_DIR}\" KERNOUT=\"${KV_OUT_DIR}\""
	CONFIG_CHECK="SND_RAWMIDI SND_VIRMIDI"
	linux-mod_pkg_setup
}

src_unpack () {
	unpack ${A}
	rpm_unpack "./kernel module/hdjmod-dkms-${PV}-1.noarch.rpm"
	mv usr/src/hdjmod-${PV} "${S}" || die
}

src_prepare() {
	epatch "${FILESDIR}"/dj_console_mp3_e2.patch
	epatch "${FILESDIR}"/kernel_2.6.31_fix.patch
	epatch "${DISTDIR}"/${PN}-kernel_2.6.35_fix.patch
	epatch "${FILESDIR}"/kernel_2.6.37_fix.patch
}
