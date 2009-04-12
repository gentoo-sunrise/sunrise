# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

DESCRIPTION="Twitter client for Linux using Qt4"
HOMEPAGE="http://www.twittare.com"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/qt-core
	x11-libs/qt-gui
	x11-libs/libnotify"
RDEPEND="${DEPEND}"

src_compile() {
	eqmake4
	emake -C libtwnotification || die "emake libtwnotification failed"
	emake || die "emake failed"
}

src_install() {
	dobin twittare || die "dobin failed"
	dolib.so libtwnotification/libtwnotification.so || die "dolib.so failed"
	insinto /usr/share/applications
	doins twittare.desktop || die "doins twittare.desktop failed"
	insinto /usr/share/pixmaps
	doins pixmaps/twittare-blue.png pixmaps/twittare-pink.png || die "doins pixmaps failed"
	insinto /usr/share/${PN}
	doins -r lang/ || die "doins lang failed"
	dodoc NEWS README ChangeLog || die "dodoc failed"
}
