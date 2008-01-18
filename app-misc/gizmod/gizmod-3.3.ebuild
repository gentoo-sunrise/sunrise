# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
	dev-libs/boost
	libvisual? ( >=media-libs/libvisual-0.4.0 )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

pkg_setup() {
	if ! built_with_use  dev-libs/boost threads ; then
		eerror "boost was not merged with the threads"
		eerror "USE flag.  Gizmo Daemon requires boost be"
		eerror "built with this flag"
		die "boost missing threads support"
	fi
}

src_compile() {
	econf --with-boost $(use_enable libvisual visplugin) || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}
