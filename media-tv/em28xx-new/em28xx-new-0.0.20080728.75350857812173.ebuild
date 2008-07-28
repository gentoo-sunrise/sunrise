# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info linux-mod versionator

printf -v EHG_REVISION '%012x' "$(get_version_component_range 4)"

DESCRIPTION="next generation em28xx driver including dvb support"
HOMEPAGE="http://mcentral.de/"
SRC_URI="http://mcentral.de/hg/~mrec/${PN}/archive/${EHG_REVISION}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${EHG_REVISION}

CONFIG_CHECK="VIDEO_V4L2 DVB_CORE"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 21; then
		eerror "You need at least kernel 2.6.21"
		die "Kernel too old"
	fi

	ebegin "Checking for CONFIG_VIDEO_EM28XX disabled"
	! linux_chkconfig_present VIDEO_EM28XX
	eend $?
	if [[ $? -ne 0 ]]; then
		ewarn "In-kernel em28xx drivers enabled, disable or remove them from"
		ewarn "/lib/modules/${KV_FULL} if you experience problems."
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
	doins $(echo {!(precompiled)/,}*.ko)
	eval ${extglob_bak} # restore previous extglob status
}
