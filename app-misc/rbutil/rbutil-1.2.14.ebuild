# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
LANGS="cs de fi fr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit eutils qt4-r2

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/twiki/bin/view/Main/RockboxUtility"
SRC_URI="http://download.rockbox.org/${PN}/source/RockboxUtility-v${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="media-libs/speex
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	virtual/libusb:0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/RockboxUtility-v${PV}/${PN}/${PN}qt"

src_configure() {
	# generate binary translations
	lrelease ${PN}qt.pro || die

	# noccache is required in order to call the correct compiler
	eqmake4 CONFIG+=noccache
}

src_install() {
	newbin RockboxUtility ${PN} || die
	# FIXME: is this the right icon?
	newicon icons/rockbox.ico ${PN}.png || die
	make_desktop_entry ${PN} "Rockbox Utility"
}
