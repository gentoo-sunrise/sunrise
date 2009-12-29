# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4
MY_PN="FreeGo"
MY_P=${MY_PN}${PV}

DESCRIPTION="Tool for users of Free, a French ISP, to manage their accounts"
HOMEPAGE="http://www.free-go.net/"
SRC_URI="http://www.freego.fr/logiciel/linux/sources/${MY_P}-src.zip"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e \
		's:PREFIX.*=.*:PREFIX=/usr:' ${MY_P}.pro \
		|| die "sed failed"
}

src_compile() {
	eqmake4 ${MY_P}.pro
	emake || die "emake failed"
}

src_install() {
	emake \
		INSTALL_ROOT="${D}" \
		install || die "emake install failed"

	dobin ${MY_PN}
	if use doc ; then
		dodoc "Guide d'utilisation de FreeGo.pdf" || die
	fi;
}
