# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

SDK_V="3.0.4.669"
MY_P="${PN}_${PV}"

DESCRIPTION="A part of the Palm Mojo SDK for communication with and rootaccess to the webOS based devices"
HOMEPAGE="http://developer.palm.com/"
SRC_URI="amd64? (
	https://cdn.downloads.palm.com/sdkdownloads/${SDK_V}/sdkBinaries/${MY_P}_amd64.deb )
	x86? (
	http://cdn.downloads.palm.com/sdkdownloads/${SDK_V}/sdkBinaries/${MY_P}_i386.deb )"

LICENSE="PalmSDK"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""
# May not be necessary. 
RESTRICT="mirror"

RDEPEND="virtual/libusb:0"

S=${WORKDIR}

QA_PRESTRIPPED="/opt/palm-novacom/novacom
	/opt/palm-novacom/novacomd"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
}

src_install() {
	exeinto opt/${PN}
	doexe opt/Palm/novacom/novacom{,d} || die

	dobin opt/Palm/novacom/novaterm || die
	newbin "${FILESDIR}/${PN}-novacom.sh" novacom || die

	newsbin "${FILESDIR}/${PN}-novacomd.sh" novacomd || die

	newinitd "${FILESDIR}/${PN}-initd" novacom || die
}

pkg_postinst() {
	einfo "To use, start the novacom daemon;"
	einfo "  /etc/init.d/novacom start"
	einfo "Then attach your Palm device with Developer Mode enabled,"
	einfo "select 'Just Charge' and run novaterm"
}
