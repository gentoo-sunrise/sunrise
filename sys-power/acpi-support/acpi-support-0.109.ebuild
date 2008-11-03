# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Ubuntu scripts and events for acpid, power management, and vendor-specific laptop configuration"
HOMEPAGE="http://packages.ubuntu.com/feisty/admin/acpi-support"
SRC_URI="mirror://ubuntu/pool/main/a/acpi-support/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X hibernate-script video_cards_radeon"

RDEPEND="sys-power/acpid
	sys-apps/kbd
	sys-apps/dmidecode
	sys-apps/vbetool
	sys-apps/ethtool
	sys-power/powermgmt-base
	hibernate-script? ( sys-power/hibernate-script )
	X? ( x11-apps/xset )
	video_cards_radeon? ( app-laptop/radeontool )"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-gentoo.patch"
	use hibernate-script && sed -i '/USE_HIBERNATE_SCRIPT=true/ s/# //' "${S}/acpi-support"
	use video_cards_radeon && sed -i '/RADEON_LIGHT=true/ s/# //' "${S}/acpi-support"
	use X || sed -i '/xset/ s/\(.*\)/#\1/' "${S}/"{lid.sh,lib/screenblank}
	sed -i "s!/etc/default/acpi-support!/etc/conf.d/${PN}!" "${S}/"{*.sh,vbesave} || die "sed failed"
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
	elog
	elog "app-laptop/laptop-mode-tools"
	elog "app-laptop/toshset"
	elog "sys-power/kpowersave"
	elog "sys-power/powersave"
	elog "sys-apps/855resolution"
	elog "sys-apps/pcmciautils"
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
