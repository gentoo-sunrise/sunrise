# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="${PN/q/Q}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="a gtk/glade front-end for Qemu"
HOMEPAGE="http://qemulator.createweb.de/"
SRC_URI="http://qemulator.createweb.de/plugins/downloads/dodownload.php?file=${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/pygtk-2.8.6
	>=app-emulation/qemu-0.8.1"

S=${WORKDIR}/${MY_P}

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-basedir.patch"

}

src_install() {
	dobin usr/local/bin/*
	insinto /usr
	doins -r usr/local/{lib,share}
	dodoc TRANSLATION README
}
