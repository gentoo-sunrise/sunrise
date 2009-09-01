# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI=2

inherit base flag-o-matic

DESCRIPTION="Interactive plotting program"
HOMEPAGE="http://kavli.nano.tudelft.nl/~gsteele/spyview/"
SRC_URI="http://kavli.nano.tudelft.nl/~gsteele/${PN}/versions/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=dev-libs/boost-1.36
	media-libs/netpbm
	x11-libs/fltk:1.1
	virtual/ghostscript"

DEPEND="${COMMON_DEPEND}
	sys-apps/groff"

RDEPEND="${COMMON_DEPEND}
	sci-visualization/gnuplot"

S=${WORKDIR}/spyview-2009-08-28-23_55

src_configure() {
	append-cflags $(fltk-config --cflags)
	append-cxxflags $(fltk-config --cxxflags) -I/usr/include/netpbm

	# append-ldflags $(fltk-config --ldflags)
	# this one leads to an insane amount of warnings

	append-ldflags -L/usr/lib/fltk-1.1

	econf --datadir=/usr/share/spyview
}
