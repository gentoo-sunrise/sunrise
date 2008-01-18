# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit qt4

MY_PN="${PN}-src"

DESCRIPTION="Monkey Studio is a cross platform Qt 4 IDE"
HOMEPAGE="http://monkeystudio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.zip"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND=">=x11-libs/qt-4.0:4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	sed -i \
		-e 's#/build/#build/#g' \
		"${S}/monkey.pro" || die "build-dir fix failed"
}

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	dodoc {Readme,ToDo,WishList,Informations,Changes,Bugs}.txt
	dobin binary/monkey_x11
	dosym monkey_x11 /usr/bin/monkeystudio
	use doc && dohtml -r docqt4ds/english/html/*
}
