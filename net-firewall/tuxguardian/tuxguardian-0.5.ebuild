# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod qt3

DESCRIPTION="An application based firewall for Linux"
HOMEPAGE="http://tuxguardian.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="$(qt_min_version 3.1)"
RDEPEND="${DEPEND}"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 2 6 12; then
		die "${P} needs a kernel >=2.6.12!"
	fi
	if ! linux_chkconfig_present SECURITY; then
		eerror "${P} needs \"different security models\" in kernel enabled (SECURITY=Y)"
		eerror "AND Default Linux Capabilities build as module (SECURITY_CAPABILITIES=M)"
		die "Kernel config not suitable"
	fi
	if ! linux_chkconfig_module SECURITY_CAPABILITIES; then
		eerror "${P} needs \"Default Linux Capabilities\" build as module"
		die "Kernel config not suitable"
	fi
	MODULE_NAMES="tuxg(extra:${S}/module)"
	BUILD_PARAMS="KERNEL_SRC=${KERNEL_DIR}"
}
src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/Makefile-gentoo-0.5.patch
}
src_compile() {
	linux-mod_src_compile
	emake DESTDIR="${D}" || die "emake failed"
}

src_install() {
	linux-mod_src_install
	emake DESTDIR="${D}" install || die "einstall failed"
	newinitd "${FILESDIR}"/tuxguardian.init tuxguardian
	linux-mod_pkg_preinst
	dodoc README COPYING AUTHORS
}

pkg_postinst() {
	elog "Init script installed. use:"
	elog "rc-update add tuxguardian {runlevel} (runlevel e.g. boot)"
	elog "Toubleshooting:"
	elog "Sometimes it occures, that the module freezes.. Use:"
	elog "\"etc/init.d/tuxguardian restart\" to solve this"
	elog "tg-frontend is the frontend to tuxguardian. Unfortunatly it needs superuser rights to run."
	elog "Notice: if you decide not to use the tg-frontend please refer to the documentation, how to"
	elog "edit \"/etc/daemon.conf\""
}
