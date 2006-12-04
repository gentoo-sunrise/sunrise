# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python bindings for rb_libtorrent"
HOMEPAGE="http://deluge-torrent.org"
SRC_URI="http://deluge.mynimalistic.net/downloads/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/${PN}"

DEPEND=">=dev-lang/python-2.3
		dev-libs/boost"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use dev-libs/boost threads; then
		eerror "dev-libs/boost has to be built with threads USE-flag."
		die "Missing threads USE-flag for dev-libs/boost"
	fi
}

