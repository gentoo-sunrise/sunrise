# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="System tray utility including support for KDE system tray icons."
HOMEPAGE="http://stalonetray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="kde"

DEPEND="x11-libs/libX11
	x11-libs/libICE
	x11-libs/libXpm"

RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_enable kde native-kde) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README stalonetrayrc.sample TODO
	dohtml stalonetray.html
}
