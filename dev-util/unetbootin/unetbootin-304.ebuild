# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Universal Netboot Installer is a cross-platform utility that can create Live USB systems"
HOMEPAGE="http://unetbootin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( ( x11-libs/qt-gui x11-libs/qt-core ) >=x11-libs/qt-4.2.0 )
	sys-fs/mtools"

DEPEND="${RDEPEND}"

src_unpack(){
	unpack ${A}
	cp unetbootin.pro unetbootin-pro.bak
	sed -i '/^RESOURCES/d' unetbootin.pro
}

src_compile(){
	lupdate unetbootin.pro
	lrelease unetbootin.pro
	qmake "DEFINES += NOSTATIC" "RESOURCES -= unetbootin.qrc"||die "qmake failed"
	emake || die "emake failed"
}

src_install(){
	dobin unetbootin || die "dobin failed"
}
