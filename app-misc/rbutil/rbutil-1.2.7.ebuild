# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
LANGS="cs de fi fr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit eutils qt4-r2

MY_P=${PN}_${PV}

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/twiki/bin/view/Main/RockboxUtility"
SRC_URI="http://download.rockbox.org/${PN}/source/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="media-libs/speex
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	virtual/libusb:0"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}/${PN}

src_configure() {
	# noccache is required in order to call the correct compiler
	eqmake4 CONFIG+=noccache
}

src_install() {
	newbin rbutilqt/RockboxUtility ${PN} || die
	newicon rbutilqt/icons/rockbox-5.png ${PN}.png || die
	make_desktop_entry ${PN} "Rockbox Utility"
}
