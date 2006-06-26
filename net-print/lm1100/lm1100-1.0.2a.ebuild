# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="The Tim Engler's Lexmark 1100 driver"
HOMEPAGE="http://www.linuxprinting.org/show_driver.cgi?driver=lm1100"
MY_P=${P/lm1100-/lm1100.}
SRC_URI="http://gentooexperimental.org/~genstef/dist/${MY_P}.tar.gz
	http://gentooexperimental.org/~genstef/dist/${PN}maint.tar.gz"
#http://www.linuxprinting.org/download/printing/${PN}/${PN}maint.tar.gz
#http://www.linuxprinting.org/download/printing/${PN}/${MY_P}.tar.gz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-fix-compile-gcc-3.4.patch"
	epatch "${FILESDIR}/${P}-class.patch"
	epatch "${FILESDIR}/${P}-makefile.patch"

	cd "${WORKDIR}/${PN}maint"
	epatch "${FILESDIR}/${PN}maint-firmware.patch"
}

src_install() {
	dobin lm1100
	dodoc README RELEASE.txt LICENSE

	cd "${WORKDIR}/${PN}maint"
	dobin lm1100back lm1100change
	insinto "/lib/firmware/${PN}maint"
	doins lexmarkback lexmarkchange
	newdoc README README.maint
}
