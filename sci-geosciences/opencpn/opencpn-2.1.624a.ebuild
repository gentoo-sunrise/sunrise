# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils

MY_P=OpenCPN-${PV}-Source
DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="http://opencpn.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/bzip2
	media-libs/mesa
	sys-libs/zlib
	x11-libs/wxGTK:2.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# force to disable usage of libgps until we have
	# gpsd >= 2.90 available in the tree (bug #305317)
	local mycmakeargs="-DUSE_GPSD=OFF"
	cmake-utils_src_configure
}
