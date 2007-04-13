# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Ubuntu scripts and events for acpid, power management, and vendor-specific laptop configuration"
HOMEPAGE="http://packages.ubuntu.com/feisty/admin/acpi-support"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/a/acpi-support/acpi-support_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="kde laptop-mode pcmcia toshiba intel-855 X video_cards_radeon"

DEPEND=""
RDEPEND="sys-power/acpid
	sys-apps/kbd
	sys-apps/dmidecode
	sys-apps/vbetool
	sys-apps/ethtool
	sys-power/powermgmt-base
	X? ( x11-apps/xset )
	kde? ( =kde-base/kdelibs-3.5* )
	toshiba? ( app-laptop/toshset )
	laptop-mode? ( app-laptop/laptop-mode-tools )
	video_cards_radeon? ( app-laptop/radeontool )
	pcmcia? ( >=sys-apps/pcmciautils-013 )
	intel-855? ( sys-apps/855resolution )"

# Say thanks to whoever packaged this...
S=${WORKDIR}/${PN}-0.94

src_unpack() {
	unpack ${A}
	use video_cards_radeon && sed -i '/RADEON_LIGHT=true/ s/# //' "${S}/acpi-support" || die "sed failed"
	use X || sed -i '/xset/ s/\(.*\)/#\1/' "${S}/"{lid.sh,lib/screenblank} || die "sed failed"
	sed -i "s!/etc/default/acpi-support!/etc/conf.d/${PN}!" "${S}/"{*.sh,vbesave} || die "sed failed"
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_compile() {
	sed -i 's/strip acpi_fakekey//' Makefile
	emake || die "emake failed"
}

src_install() {
	dobin acpi_fakekey

	insinto /usr/share/${PN}
	doins key-constants lib/*

	insinto /etc/acpi
	insopts -m755
	doins *.sh
	doins -r *.d events

	doconfd ${PN}
	newinitd debian/init.d ${PN}

	keepdir /etc/acpi/{local,{resume,battery,events,suspend,start,ac}.d} /var/lib/${PN}
	dodoc README
}

pkg_postinst() {
	elog "You may wish to read the Gentoo Linux Power Management Guide,"
	elog "which can be found online at:"
	elog
	elog "http://www.gentoo.org/doc/en/power-management-guide.xml"
	elog
	elog "The following packages provide additional functionality:"
	elog "sys-power/powersave"
	elog "sys-power/kpowersave"
	elog "app-laptop/laptop-mode-tools"
	elog
	elog "To initialize power management options for your devices at"
	elog "system startup, please run the following:"
	elog
	elog "rc-update add ${PN} default"
	elog
	elog "This package will not work until you restart acpid. Please run the following:"
	elog
	elog "/etc/init.d/acpid restart"
}
