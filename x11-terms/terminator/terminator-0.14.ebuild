# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="http://www.tenshu.net/terminator/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND="gnome? ( dev-python/gnome-python )
	>=x11-libs/vte-0.16[python]"

src_prepare() {
	epatch "${FILESDIR}"/${P}-without-icon-cache.patch
	distutils_src_prepare
}
