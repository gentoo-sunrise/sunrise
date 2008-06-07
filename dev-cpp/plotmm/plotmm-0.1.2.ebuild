# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="Plot widget for GTKmm"
HOMEPAGE="http://plotmm.sourceforge.net/"
SRC_URI="mirror://sourceforge/plotmm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.0
		dev-libs/libsigc++:2"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9"

src_install() {
	make install DESTDIR="${D}" || die "install failed"

	dodoc AUTHORS ChangeLog INSTALL NEWS README || die
	cp -R doc "${D}/usr/share/doc/${P}"
}

