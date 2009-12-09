# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit base

DESCRIPTION="Program for converting the DAA and GBI files (used by PowerISO and gBurner) to ISO"
HOMEPAGE="http://aluigi.org/mytoolz.htm"
SRC_URI="http://aluigi.org/mytoolz/${PN}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/src"
PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}
