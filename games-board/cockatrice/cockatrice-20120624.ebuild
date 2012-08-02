# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games cmake-utils

DESCRIPTION="Cockatrice is an open-source multiplatform software for playing card games over a network"
HOMEPAGE="http://cockatrice.de/"
SRC_URI="${HOMEPAGE}files/${PN}_source_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+client"

RDEPEND="
	dev-libs/libgcrypt
	dev-libs/protobuf
	x11-libs/qt-core:4
	x11-libs/qt-sql:4
	client? (
		x11-libs/qt-multimedia:4
		x11-libs/qt-svg:4
		x11-libs/qt-gui:4
	)
	"

S="${WORKDIR}/${PN}_${PV}"

src_prepare() {
	# Patch CMakeLists.txt to install servatrice.
	epatch "${FILESDIR}/${PN}-20120630-servatrice-cmakelists.patch"
}

src_configure() {
	# Always compile server support.
	local mycmakeargs="-DWITH_SERVER=1"
	if ! use client; then
		# Compile client UI, if client use-flag is set.
		mycmakeargs="${mycmakeargs} -DWITHOUT_CLIENT=1"
	fi
	cmake-utils_src_configure
}
