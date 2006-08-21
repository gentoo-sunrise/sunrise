# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="wine config tool"
HOMEPAGE="http://www.von-thadden.de/Joachim/WineTools/index.html"
SRC_URI="http://ds80-237-203-29.dedicated.hosteurope.de/wt/${P}jo-III.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-devel/gettext
	x11-misc/xdialog
	app-emulation/wine"

MY_P=${P}jo-III
S="${WORKDIR}"/"${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${MY_P}"
	epatch "${FILESDIR}"/${P}.wt0.9jo.diff
	epatch "${FILESDIR}"/${P}.findwine.diff
}

src_install() {
	insinto /usr/winetools/

	cd "${S}"

	doins -r 3rdParty icon po scripts
	dodoc doc/*
	doins chopctrl.pl findwine gettext.sh.dummy listit wt-config.reg
	
	newins wt0.9jo wt
	fperms 755 /usr/winetools/wt

	dosym /usr/winetools/wt /usr/bin/wt
	dosym /usr/winetools/findwine /usr/bin/findwine
}

pkg_postinst() {
	einfo " "
	einfo "Start WineTools as *normal* user with \"wt\". Don't use as root!"
	einfo " "
}
