# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EHG_REPO_URI="http://mcentral.de/hg/~mrec/em28xx-new/"

inherit linux-info linux-mod mercurial

DESCRIPTION="next generation em28xx driver including dvb support"
HOMEPAGE="http://mcentral.de/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

MODULE_NAMES="cx25843(empia:${S}/cx25843:${S}/cx25843)
	drx3973d(empia:${S}/drx3973d:${S}/drx3973d)
	lgdt3304-demod(empia:${S}/lgdt3304:${S}/lgdt3304)
	mt2060(empia:${S}/mt2060:${S}/mt2060)
	qt1010(empia:${S}/qt1010:${S}/qt1010)
	tvp5150(empia:${S}/tvp5150:${S}/tvp5150)
	xc3028-tuner(empia:${S}/xc3028:${S}/xc3028)
	xc5000-tuner(empia:${S}/xc5000:${S}/xc5000)
	zl10353(empia:${S}/zl10353:${S}/zl10353)
	em28xx-audio(empia:${S}:${S})
	em28xx-dvb(empia:${S}:${S})
	em28xx(empia:${S}:${S})"

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
