# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="C++ class to interact with museekd."
HOMEPAGE="http://projects.beep-media-player.org/index.php/Main/Moodriver"
SRC_URI="http://files.beep-media-player.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.8.0
		>=dev-libs/libsigc++-2.0"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9.0"


src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
