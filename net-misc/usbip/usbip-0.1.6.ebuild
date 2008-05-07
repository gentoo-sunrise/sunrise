# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils linux-info linux-mod

DESCRIPTION="A general USB device sharing system over IP networks"
HOMEPAGE="http://usbip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=sys-fs/sysfsutils-2
	sys-apps/tcp-wrappers
	dev-libs/glib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/automake-1.9
	sys-devel/libtool"

MODULE_NAMES="usbip(usbip:${S}/drivers/head:${S}/drivers/head) usbip_common_mod(usbip:${S}/drivers/head:${S}/drivers/head) vhci-hcd(usbip:${S}/drivers/head:${S}/drivers/head)"
BUILD_PARAMS=""

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 24
	then
		eerror "You need at least kernel 2.6.24"
		die "Kernel too old"
	fi

	ebegin "Checking for CONFIG_USB enabled"
	linux_chkconfig_present USB
	eend $?
	[[ $? -ne 0 ]] && die "USB is not enabled in the kernel."

	if use debug
	then
		ebegin "Checking for CONFIG_USB_DEBUG enabled"
	        linux_chkconfig_present USB_DEBUG
		eend $?
		[[ $? -ne 0 ]] && die "USE=debug requires that USB debugging is enabled in the kernel."
		BUILD_PARAMS+="DEBUG=y"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"/src
	eautoreconf
}

src_compile() {
	# compiling kernel modules
	cd "${S}"/drivers/head
	emake ARCH="$(tc-arch-kernel)" ${BUILD_PARAMS} || die "Compiling kernel modules failed"

	# compiling userspace tools
	cd "${S}"/src
	econf
	emake KSOURCE="${KV_DIR}" || die "Compiling userspace tools failed"
}

src_install() {
	linux-mod_src_install

	cd "${S}"/src
	emake DESTDIR="${D}" install || die "Installing userspace tools failed"
	dodoc README* || die
}
