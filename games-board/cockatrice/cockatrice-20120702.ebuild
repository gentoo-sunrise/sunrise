# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils gnome2-utils games

DESCRIPTION="Cockatrice is an open-source multiplatform software for playing card games over a network"
HOMEPAGE="http://cockatrice.de/"
SRC_URI="${HOMEPAGE}files/${PN}_source_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated server"

RDEPEND="
	dev-libs/libgcrypt
	dev-libs/protobuf
	x11-libs/qt-core:4
	x11-libs/qt-sql:4
	!dedicated? (
		x11-libs/qt-multimedia:4
		x11-libs/qt-svg:4
		x11-libs/qt-gui:4
	)
	"

S="${WORKDIR}/${PN}_${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch \
			"${FILESDIR}"/${P}-underlinking.patch
}

src_configure() {
	local mycmakeargs=(
			$(usex dedicated "-DWITHOUT_CLIENT=1 -DWITH_SERVER=1" "$(usex server "-DWITH_SERVER=1" "")")
			-DCMAKE_INSTALL_BINDIR="${GAMES_BINDIR}"
			-DCMAKE_INSTALL_PREFIX="${GAMES_PREFIX}"
			-DICONDIR="/usr/share/icons"
			-DDESKTOPDIR="/usr/share/applications"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	use dedicated || gnome2_icon_cache_update
}

pkg_postrm() {
	use dedicated || gnome2_icon_cache_update
}
