# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="Multiplayer game network engine"
HOMEPAGE="http://www.rakkarsoft.com/"
SRC_URI="http://perso.renchap.com/${P}.tgz"

LICENSE="CCPL-Attribution-NonCommercial-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.diff
	ebegin "Setting makefile variables"
	echo "VERSION = ${PV}" >> "${S}"/makefile.defs
	echo "LIBS_DIR = ${D}/usr/$(get_libdir)" >> "${S}"/makefile.defs
	echo "INCLUDE_DIR = ${D}/usr/include" >> "${S}"/makefile.defs
	eend
}

src_compile() {
	emake -j1 || die "emake failed!"
}

src_install() {
	dolib.so Lib/linux/libraknet.so.${PV}
	dosym /usr/$(get_libdir)/libraknet.so.${PV} /usr/$(get_libdir)/libraknet.so

	insinto /usr/include/raknet
	doins Include/*

	dodoc readme.txt
	dohtml Help/*
}
