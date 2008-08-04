# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils

DESCRIPTION="Plot widget for GTKmm"
HOMEPAGE="http://plotmm.sourceforge.net/"
SRC_URI="mirror://sourceforge/plotmm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=dev-cpp/gtkmm-2.0
		dev-libs/libsigc++:2"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-libsigc++-2.2.patch"
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README || die

	if use doc; then
		dohtml -r doc/html/* || die "dohtml failed"
	fi
}
