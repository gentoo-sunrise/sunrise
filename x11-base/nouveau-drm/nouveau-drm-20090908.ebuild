# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit linux-info linux-mod

DESCRIPTION="Nouveau DRM Kernel Modules for X11"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI="http://omploader.org/vMjh2cA/${P}.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="virtual/linux-sources
	!x11-base/x11-drm"
RDEPEND="${DEPEND}"

S=${WORKDIR}/master-compat

CONFIG_CHECK="~BACKLIGHT_CLASS_DEVICE !DRM ~FB_CFB_FILLRECT ~FB_CFB_COPYAREA ~FB_CFB_IMAGEBLIT ~!FB_VESA ~!FB_UVESA ~FRAMEBUFFER_CONSOLE"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 29; then
		eerror "You need at least kernel 2.6.29"
		die "Kernel too old"
	fi
}

src_compile() {
	cd nouveau || die "cd failed"
	set_arch_to_kernel
	emake LINUXDIR="${KERNEL_DIR}" || die "Compiling kernel modules failed"
}

src_install() {
	insinto "/lib/modules/${KV_FULL}/${PN}"
	doins drivers/gpu/drm/{*/,}*.ko || die "doins failed"
}
