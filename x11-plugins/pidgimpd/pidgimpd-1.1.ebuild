# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="PidgiMPD is a Pidgin plugin for monitoring/controlling MPD."
HOMEPAGE="http://ayeon.org/projects/pidgimpd/"
SRC_URI="http://ayeon.org/projects/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="net-im/pidgin[gtk]
	media-libs/libmpd"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO || die "dodoc failed"
}
