# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${P}jo-III
S=${WORKDIR}/${MY_P}

DESCRIPTION="graphical wine tool for installing Windows programs under wine"
HOMEPAGE="http://www.von-thadden.de/Joachim/WineTools/index.html"
SRC_URI="http://ds80-237-203-29.dedicated.hosteurope.de/wt/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-devel/gettext
	x11-misc/xdialog
	app-emulation/wine"

src_unpack() {
	unpack ${A}
	cd "${MY_P}"
	epatch ${FILESDIR}/${P}.wt0.9jo.diff
	epatch ${FILESDIR}/${P}.findwine.diff
}

src_install() {
	insinto /usr/winetools/
	cd "${S}"

	dodoc doc/*
	doins -r 3rdParty icon scripts po
	doins chopctrl.pl findwine gettext.sh.dummy listit wt-config.reg

	newins wt0.9jo wt
	fperms 755 /usr/winetools/wt

	dosym /usr/winetools/wt /usr/bin/wt
	dosym /usr/winetools/findwine /usr/bin/findwine
}

pkg_postinst() {
	elog " "
	elog "Start WineTools as *normal* user with \"wt\". Don't use as root!"
	elog " "
}
