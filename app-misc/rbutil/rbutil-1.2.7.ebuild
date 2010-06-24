# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
LANGS="cs de fi fr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit eutils qt4-r2

MY_P=${P/-/_}

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/twiki/bin/view/Main/RockboxUtility"
SRC_URI="http://download.rockbox.org/${PN}/source/${MY_P}-src.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	virtual/libusb:0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/${PN}"

src_install() {
	newbin "${S}"/rbutilqt/RockboxUtility ${PN} || die "newbin failed"
	newicon "${S}"/rbutilqt/icons/rockbox.ico ${PN}.ico || die "newicon failed"
	make_desktop_entry ${PN} "Rockbox Utility" /usr/share/pixmaps/${PN}.ico || die "make_desktop_entry failed"
}
