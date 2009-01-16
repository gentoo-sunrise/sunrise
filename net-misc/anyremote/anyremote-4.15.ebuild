# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Anyremote provides wireless Bluetooth or infrared remote control service, but works also with cable"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth gnome kde"

RDEPEND="bluetooth? ( net-wireless/bluez-libs net-wireless/bluez-utils )
	x11-libs/libXtst"

DEPEND="${RDEPEND}"

PDEPEND="kde? ( net-misc/kanyremote )
	  gnome? ( net-misc/ganyremote )"

src_configure() {
	econf $(use_enable bluetooth bluez)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "install doc failed"
}
