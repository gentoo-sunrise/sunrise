# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit linux-mod eutils git-2
KEYWORDS=""
SLOT="0"
LICENSE="GPL-2"

DESCRIPTION="Modules to turn off nVidia card for ASUS laptops"
HOMEPAGE="https://github.com/awilliam/asus-switcheroo"

IUSE="video_cards_intel video_cards_nouveau video_cards_nvidia"
REQUIRED_USE="video_cards_nouveau? ( !video_cards_nvidia )"

DEPEND="sys-power/pm-utils"
RDEPEND="${DEPEND}"

EGIT_REPO_URI="git://github.com/awilliam/${PN}.git"

BUILD_TARGETS="default"

pkg_setup() {
	MODULE_NAMES="${PN}(extra/${PN}:${S})"
	use video_cards_intel && MODULE_NAMES="${MODULE_NAMES}  i915-jprobe(extra/${PN}:${S})"
	use video_cards_nouveau && MODULE_NAMES="${MODULE_NAMES}  nouveau-jprobe(extra/${PN}:${S})"

	linux-mod_pkg_setup
}

src_install(){
	linux-mod_src_install
	exeinto /etc/pm/sleep.d
	doexe  ${PN}-pm

	if use video_cards_nvidia ; then
		insinto /etc/modprobe.d
		newins "${FILESDIR}"/${PN}.conf-nvidia ${PN}.conf

		newinitd "${FILESDIR}"/switcheroo.rc switcheroo

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
	elog " add this to your /etc/fstab:"
	elog ""
	elog " debugfs /sys/kernel/debug debugfs defaults 0 0"
	elog ""
	elog "Remember to add asus_switcheroo to /etc/conf.d/modules"
	elog ""
	elog "To turn off the discrete card on boot, put"
	elog ""
	elog 'if [ -f "/sys/kernel/debug/vgaswitcheroo/switch" ] ; then '
	elog "   /bin/echo OFF > /sys/kernel/debug/vgaswitcheroo/switch"
	elog "fi"
	elog ""
	elog "in /etc/conf.d/local.start"

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
