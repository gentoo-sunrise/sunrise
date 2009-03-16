# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Input event scripting utility that has special support for fancy keyboards, mice, USB dials and more"
HOMEPAGE="http://gizmod.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libvisual"
RDEPEND="x11-libs/libX11
	dev-lang/python
	media-libs/alsa-lib
	|| ( dev-libs/boost[threads] >=dev-libs/boost-1.34 )
	libvisual? ( >=media-libs/libvisual-0.4.0 )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_configure() {
	econf --with-boost $(use_enable libvisual visplugin)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}
