# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

MY_P="FreeGo${PV}"

DESCRIPTION="Tool for users of Free, a French ISP, to manage their accounts"
HOMEPAGE="http://www.free-go.net/"
SRC_URI="http://www.freego.fr/logiciel/linux/sources/${MY_P}-src.zip"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="x11-libs/qt-gui:4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e 's:PREFIX.*=.*:PREFIX=/usr:' ${MY_P}.pro || die
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die

	dobin FreeGo || die
	if use doc; then
		dodoc "Guide d'utilisation de FreeGo.pdf" || die
	fi
}
