# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WX_GTK_VER="2.8"

inherit cmake-utils wxwidgets

MY_P=OpenCPN-${PV}-Source
DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="http://opencpn.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gpsd"

DEPEND="app-arch/bzip2
	media-libs/mesa
	gpsd? ( >=sci-geosciences/gpsd-2.90 )
	sys-devel/gettext
	sys-libs/zlib
	x11-libs/wxGTK:2.8[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs=( $(cmake-utils_use_use gpsd) )
	cmake-utils_src_configure
}

## USE flag settings that didn't work. Will contact upstream about this.
# WiFi is an additional option accoring CMakeLists.txt, but compile fails when
# enabled.
# local mycmakeargs=( ${mycmakeargs} $(cmake-utils_use_use wifi WIFI) )

# Garmin Host Mode is optional according CMakeLists.txt, but compile fails when
# disabled.
# local mycmakeargs=( ${mycmakeargs} $(cmake-utils_use_use garminhost GARMINHOST) )

# S57 ENC chart support is optional according CMakeLists.txt, but compile fails
# when disabled.
# local mycmakeargs=( ${mycmakeargs} $(cmake-utils_use_use s57 S57) )
