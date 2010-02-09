# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="CoovaChilli"
DESCRIPTION="CoovaChilli is an open-source software access controller, based on
the ChilliSpot project."
HOMEPAGE="http://www.coova.org/CoovaChilli"
SRC_URI="http://ap.coova.org/chilli/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	# We need to overwrite the provided init script
	doinitd "${FILESDIR}"/chilli || die "doinitd failed"

	dodoc doc/hotspotlogin.cgi "${FILESDIR}"/firewall.iptables || die "dodoc
	failed"
}

pkg_postinst() {
	elog "$MY_PN uses RADIUS for access provisioning and accounting so be sure"
	elog "to install and configure a RADIUS server before using ${MY_PN}."
	elog "Gentoo-wiki has a nice guide regarding this (uses Freeradius):"
	elog "  http://en.gentoo-wiki.com/wiki/Chillispot_with_FreeRadius_and_MySQL"
}
