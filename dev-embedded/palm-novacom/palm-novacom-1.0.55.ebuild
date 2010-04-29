# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A part of the Palm Mojo SDK for communication with and rootaccess to the webOS based devices"
HOMEPAGE="http://developer.palm.com/"
SRC_URI="amd64? ( http://cdn.downloads.palm.com/sdkdownloads/1.4.1.427/sdkBinaries/${PN}_${PV}_amd64.deb )
	x86? ( http://cdn.downloads.palm.com/sdkdownloads/1.4.1.427/sdkBinaries/${PN}_${PV}_i386.deb )"

LICENSE="PalmSDK"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

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
	newbin "${FILESDIR}/${P}-novacom.sh" novacom || die

	newsbin "${FILESDIR}/${P}-novacomd.sh" novacomd || die

	newinitd "${FILESDIR}/${P}-initd" novacom || die
}

pkg_postinst() {
	elog "You may add novacom daemon to your default runlevel"
	elog "  rc-update add novacom default"
	elog "attach your Palm Pre with Developer Mode enabled,"
	elog "select 'just charge' and start novaterm"
}
