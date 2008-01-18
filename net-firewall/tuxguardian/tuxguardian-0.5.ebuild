# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils linux-mod qt3

DESCRIPTION="An application based firewall for Linux"
HOMEPAGE="http://tuxguardian.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/qt-3.1:3"
RDEPEND="${DEPEND}"

CONFIG_CHECK="SECURITY SECURITY_CAPABILITIES"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 12; then
		die "${P} needs a kernel >=2.6.12!"
	fi
	MODULE_NAMES="tuxg(extra:${S}/module)"
	BUILD_PARAMS="KERNEL_SRC=${KERNEL_DIR}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
	kernel_is gt 2 6 18 && epatch "${FILESDIR}"/${P}-config.h.patch
}

src_compile() {
	linux-mod_src_compile
	emake DESTDIR="${D}" || die "emake failed"
}

src_install() {
	linux-mod_src_install
	emake DESTDIR="${D}" install || die "install failed"
	newinitd "${FILESDIR}"/tuxguardian.init tuxguardian
	linux-mod_pkg_preinst
	dodoc README AUTHORS
}

pkg_postinst() {
	elog "Run rc-update add tuxguardian {runlevel} to start this automatically at boot"
	elog
	elog "Sometimes the module freezes; to solve this, just run"
	elog "/etc/init.d/tuxguardian restart"
	elog
	elog "tg-frontend frontend unfortunately needs superuser priviledges to run."
	elog "If you decide not to use the tg-frontend, please refer to the documentation"
	elog "and edit /etc/daemon.conf accordingly."
}
