# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python bindings for rb_libtorrent"
HOMEPAGE="http://code.google.com/p/python-libtorrent/"
SRC_URI="http://zachtib.googlepages.com/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}

RDEPEND=">=dev-lang/python-2.3
		net-libs/rb_libtorrent
		dev-libs/boost"
DEPEND="${RDEPEND}"

