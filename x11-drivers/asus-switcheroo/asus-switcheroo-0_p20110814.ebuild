# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit linux-mod eutils

DESCRIPTION="Modules to turn off nVidia card for ASUS laptops"
HOMEPAGE="https://github.com/awilliam/asus-switcheroo"

KEYWORDS="~amd64"
DEPEND="sys-power/pm-utils"
RDEPEND="${DEPEND}"
SLOT="0"
LICENSE="GPL-2"
IUSE="byo video_cards_intel video_cards_nouveau video_cards_nvidia"
REQUIRED_USE="video_cards_nouveau? ( !video_cards_nvidia )"

GITHUB_COMMIT="9231be9"
SRC_URI="http://www.github.com/awilliam/${PN}/tarball/${GITHUB_COMMIT} -> ${P}.tar.gz"
S="${WORKDIR}/awilliam-${PN}-${GITHUB_COMMIT}"

BUILD_TARGETS="default"

pkg_setup() {
	MODULE_NAMES="${PN}(extra/${PN}:${S})"
	use byo && MODULE_NAMES="byo-switcheroo(extra/${PN}:${S})"
	use video_cards_nouveau && MODULE_NAMES="${MODULE_NAMES}  nouveau-jprobe(extra/${PN}:${S})"

	if kernel_is ge 3 0 0; then
		eerror "This package has only been tested with 2.6.x version kernels"
		die
	fi

	if kernel_is ge 2 6 38; then
		CONFIG_CHECK="VGA_SWITCHEROO"
	else
		use video_cards_intel && MODULE_NAMES="${MODULE_NAMES}  i915-jprobe(extra/${PN}:${S})"
	fi

	linux-mod_pkg_setup
}

src_install(){
	linux-mod_src_install
	exeinto /etc/pm/sleep.d
	doexe  ${PN}-pm

	if kernel_is ge 2 6 38 ; then
		sed -i "/915/d" ${PN}.conf-modprobe.d
	fi

	sed -i '1ioptions asus-switcheroo ' ${PN}.conf-modprobe.d

	if ( use video_cards_nvidia || use byo) ; then
		sed -i "s:options.*oo:& dummy-client=1 \n:"  ${PN}.conf-modprobe.d
	fi

	if use video_cards_nvidia ; then
		sed -i "s:/sbin/modprobe nouveau-jprobe:/bin/echo DIS > /sys/kernel/debug/vgaswitcheroo/switch:"  ${PN}.conf-modprobe.d
		sed -i "s:ouveau:vidia:g"  ${PN}.conf-modprobe.d
	fi

	if use byo ; then
		sed -i "s:asus:byo:g"  ${PN}.conf-modprobe.d
		sed -i "s:options.*oo:&  model=AsusUL30VT:"  ${PN}.conf-modprobe.d
	fi

	if use video_cards_nvidia ; then
		sed -i '1iblacklist nvidia' ${PN}.conf-modprobe.d

		insinto /etc/modprobe.d
		newins ${PN}.conf-modprobe.d ${PN}.conf

		newinitd "${FILESDIR}"/switcheroo-dir.rc switcheroo

		exeinto /usr/sbin
		newexe "${FILESDIR}"/switcheroo-to-nvidia.sh switcheroo-to-nvidia

		insinto /etc/X11
		doins "${FILESDIR}"/xorg.conf-nvidia

	elif use video_cards_nouveau ; then
		insinto /etc/modprobe.d
		newins ${PN}.conf-modprobe.d ${PN}.conf
	fi
}

pkg_postinst() {
	elog "If debugfs isn't automatically mounted for you,"
	elog "add this to your /etc/fstab:"
	elog ""
	elog "debugfs /sys/kernel/debug debugfs defaults 0 0"
	elog ""
	elog "Remember to add asus_switcheroo or byo_switcheroo"
	elog "to /etc/conf.d/modules, and edit your laptop model."
	elog ""
	elog "To turn off the discrete card on boot, put"
	elog ""
	elog 'if [ -f "/sys/kernel/debug/vgaswitcheroo/switch" ] ; then '
	elog "   /bin/echo OFF > /sys/kernel/debug/vgaswitcheroo/switch"
	elog "fi"
	elog ""
	elog "in /etc/local.d/switcheroo.start"

	if use video_cards_nvidia ; then
		elog ""
		elog "This ebuild has installed a system for switching"
		elog "to the nVidia card and driver. This system requires"
		elog "that you use the supplied xorg.conf for nVidia"
		elog "and no xorg.conf for the intel card. The switching"
		elog "is handled by the command switcheroo-to-nvidia"
		elog "and the switcheroo init.d script."
	fi

	linux-mod_pkg_postinst
}
