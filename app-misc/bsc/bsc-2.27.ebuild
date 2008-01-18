# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils qt3

DESCRIPTION="BSCommander is a Qt based file manager"
HOMEPAGE="http://www.beesoft.org/bsc.html"
SRC_URI="http://www.beesoft.org/download/${PN}_${PV}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=x11-libs/qt-3.3:3
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	eqmake3 bsc.pro -o Makefile
	emake || die "make failed"
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}/images
	doins images/*

	insinto /usr/share/${PN}/lang
	doins *.qm

	newicon BeesoftCommander.png ${PN}.png
	make_desktop_entry ${PN} BSCommander ${PN}.png "FileManager;Utility;Qt"

	dodoc ChangeLog.txt
}
