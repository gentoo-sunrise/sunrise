# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit x-modular autotools eutils

DESCRIPTION="X.Org driver for Wiimote input devices"
HOMEPAGE="http://people.freedesktop.org/~whot/wiimote/"
SRC_URI="http://people.freedesktop.org/~whot/wiimote/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	dev-libs/libwiimote
	x11-proto/inputproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-libwiimote.patch"
	eautoreconf
}
