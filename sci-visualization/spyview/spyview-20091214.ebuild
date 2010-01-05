# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI=2

inherit base flag-o-matic eutils autotools multilib

DESCRIPTION="Interactive plotting program"
HOMEPAGE="http://kavli.nano.tudelft.nl/~gsteele/spyview/"
SRC_URI="http://kavli.nano.tudelft.nl/~gsteele/${PN}/versions/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-libs/boost-1.35
	media-libs/netpbm
	>=x11-libs/fltk-1.1.9:1.1
	app-text/ghostscript-gpl"

DEPEND="${COMMON_DEPEND}
	sys-apps/groff"

RDEPEND="${COMMON_DEPEND}
	sci-visualization/gnuplot"

S=${WORKDIR}/spyview-2009-12-14-09_17

src_prepare() {
	epatch "${FILESDIR}"/${P}-{datadir,includes}.patch

	append-cflags $(fltk-config --cflags)
	append-cxxflags $(fltk-config --cxxflags) -I/usr/include/netpbm

	# append-ldflags $(fltk-config --ldflags)
	# this one leads to an insane amount of warnings

	append-ldflags -L/usr/$(get_libdir)/fltk-1.1

	eautoreconf
}

src_configure() {
	econf --datadir=/usr/share/spyview
}
