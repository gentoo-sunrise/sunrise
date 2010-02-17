# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

MY_P="${PN}_${PV}_stable"
DESCRIPTION="A interpreted language mainly used for games"
HOMEPAGE="http://squirrel-lang.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV:0:1}/${MY_P}/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

# /usr/bin/sq conflicts
RDEPEND="!app-text/ispell"

S="${WORKDIR}/SQUIRREL${PV:0:1}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	epatch "${FILESDIR}"/${P}-supertux-const.patch
	epatch "${FILESDIR}"/${P}-stdint.h.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc HISTORY README || die
}
