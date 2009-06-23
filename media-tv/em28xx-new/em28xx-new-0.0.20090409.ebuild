# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit linux-info linux-mod versionator

DESCRIPTION="next generation em28xx driver including dvb support"
HOMEPAGE="http://mcentral.de/"
SRC_URI="http://upload.hasnoname.de/${PN}/${PN}-$(get_version_component_range 3).tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

CONFIG_CHECK="VIDEO_V4L2 DVB_CORE"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 21; then
		eerror "You need at least kernel 2.6.21"
		die "Kernel too old"
	fi

	if linux_chkconfig_present VIDEO_EM28XX; then
		ewarn "In-kernel em28xx drivers enabled, disable or remove them from"
		ewarn "/lib/modules/${KV_FULL} if you experience problems."
	fi
}

src_prepare() {
	if kernel_is eq 2 6 29; then
		epatch "${FILESDIR}"/em28xx-new-video.c-2.6.29.patch
	fi

	if kernel_is ge 2 6 30; then
		epatch "${FILESDIR}"/em28xx-new-2.6.30.patch
	fi
}

src_compile() {
	set_arch_to_kernel
	emake || die "Compiling kernel modules failed"
}

src_install() {
	insinto /lib/modules/${KV_FULL}/empia
	local extglob_bak=$(shopt -p extglob)
	shopt -s extglob # portage disables bash extglob in ebuilds
	doins $(echo {!(precompiled)/,}*.ko) || die "doins failed"
	eval ${extglob_bak} # restore previous extglob status
}
