# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Multiplayer game network engine"
HOMEPAGE="http://www.rakkarsoft.com/"
SRC_URI="http://perso.renchap.com/${P}.tgz"

LICENSE="CCPL-Attribution-NonCommercial-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	ebegin "Setting makefile variables"
	echo "VERSION = ${PV}" >> ${S}/makefile.defs
	echo "LIBS_DIR = ${D}/usr/lib" >> ${S}/makefile.defs
	echo "INCLUDE_DIR = ${D}/usr/include" >> ${S}/makefile.defs
	eend
}

src_compile() {
	emake -j1 || die "Error: emake failed!"
}

src_install() {
	dolib.so Lib/linux/libraknet.so.${PV}
	dosym /usr/lib/libraknet.so.${PV} /usr/lib/libraknet.so
	insinto /usr/include/raknet
	doins Include/*
	if use doc; then		# if the useflag doc is enabled we copy our readme as well
		dodoc readme.txt
		dohtml Help/*
	fi
}
