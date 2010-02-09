# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="2"

inherit autotools

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="CAB file creation tool"
HOMEPAGE="http://ohnopublishing.net/lcab/"
SRC_URI="ftp://ohnopublishing.net/mirror/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i "s:1.0b11:${MY_PV}:" mytypes.h || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	doman ${PN}.1 || die
	dodoc README || die
}
