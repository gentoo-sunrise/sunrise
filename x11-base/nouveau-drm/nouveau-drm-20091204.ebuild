# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit linux-info linux-mod

DESCRIPTION="Nouveau DRM Kernel Modules for X11"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI="http://omploader.org/vMnlldQ/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/linux-sources
	!x11-base/x11-drm"
RDEPEND="${DEPEND}"

S=${WORKDIR}/master

CONFIG_CHECK="~BACKLIGHT_CLASS_DEVICE ~DEBUG_FS !DRM ~FB_CFB_FILLRECT ~FB_CFB_COPYAREA ~FB_CFB_IMAGEBLIT ~!FB_VESA ~!FB_UVESA ~FRAMEBUFFER_CONSOLE"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 31; then
		eerror "You need at least kernel 2.6.31"
		die "Kernel too old"
	fi
}

src_prepare() {
	if kernel_is ge 2 6 32; then
		epatch "${FILESDIR}"/${P}-nodename_to_devnode.patch # bug 295633
	fi
}

src_compile() {
	set_arch_to_kernel
	emake LINUXDIR="${KERNEL_DIR}" NOUVEAUROOTDIR="${PWD}" -f "${FILESDIR}"/${P}-Makefile || die "Compiling kernel modules failed"
}

src_install() {
	insinto "/lib/modules/${KV_FULL}/${PN}"
	doins drivers/gpu/drm/{*/,}*.ko || die "doins failed"
}
