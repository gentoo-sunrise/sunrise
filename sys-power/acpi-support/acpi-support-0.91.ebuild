# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# sys-power/acpi-support derived from http://packages.ubuntu.com/cgi-bin/search_packages.pl?version=all&keywords=acpi-support
# Author: azazello (gentoo@horizon.ath.cx)
# See http://bugs.gentoo.org/show_bug.cgi?id=99446

inherit eutils

DESCRIPTION="Ubuntu scripts and events for acpid, power management, and vendor-specific laptop configuration"
HOMEPAGE="http://packages.ubuntu.com/feisty/admin/acpi-support"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/a/acpi-support/acpi-support_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="kde laptop-mode video_cards_radeon"

RESTRICT=mirror

DEPEND=""
RDEPEND="sys-power/acpid
         sys-apps/kbd
         sys-apps/dmidecode
         sys-apps/vbetool
         sys-power/powermgmt-base
         kde? ( =kde-base/kdelibs-3.5* )
         laptop-mode? ( =app-laptop/laptop-mode-tools )
         video_cards_radeon? ( app-laptop/radeontool )"
#         sys-power/hibernate-script
#         sys-apps/ethtool

src_unpack() {
	unpack ${A}
	use video_cards_radeon && sed -i 's/# RADEON_LIGHT=true/RADEON_LIGHT=true/' ${S}/acpi-support
	sed -i 's!/etc/default/acpi-support!/etc/conf.d/acpi-support!' ${S}/*.sh ${S}/vbesave
	sed -i 's!/usr/bin/dcop!/usr/kde/3.5/bin/dcop!' ${S}/lib/policy-funcs
	sed -i 's!finger!who!' ${S}/lib/power-funcs
	
	epatch ${FILESDIR}/${P}-gentoo.patch
	# TODO: fix acpi_fakekey, vbesave, integrate hibernate-script, ethtool, resume.d/*-855-resolution-set.sh: . /etc/default/855resolution
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
	dodoc README COPYING
}

pkg_postinst() {
#	[ -e /etc/acpi/actions/startup.d/10-save-dmidecode.sh ] \
#		&& /etc/acpi/actions/startup.d/10-save-dmidecode.sh
	einfo
	einfo "You may wish to read the Gentoo Linux Power Management Guide,"
	einfo "which can be found online at:"
	einfo
	einfo "    http://www.gentoo.org/doc/en/power-management-guide.xml"
	einfo
	einfo "The following packages provide additional functionality:"
	einfo "    sys-power/powersave"
	einfo "    sys-power/kpowersave"
	einfo "    app-laptop/laptop-mode-tools"
	einfo
	einfo "To initialize power management options for your devices at"
	einfo "system startup, please run the following:"
	einfo
	einfo "    rc-update add acpi-support default"
	einfo
}
