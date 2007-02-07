# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils

DESCRIPTION="Python bindings for rb_libtorrent"
HOMEPAGE="http://deluge-torrent.org"
SRC_URI="http://deluge-torrent.org/downloads/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use dev-libs/boost threads; then
		eerror "dev-libs/boost has to be built with threads USE-flag."
		die "Missing threads USE-flag for dev-libs/boost"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Adding boost libraries suffix, see
	# http://deluge-torrent.org/trac/ticket/62
	# for details
	sed -i -e "s:\('boost_[^']*\):\1-mt:g" setup.py
}
