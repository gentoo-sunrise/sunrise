# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils

DESCRIPTION="Make pointer-driven interfaces easier and faster for users to operate."
HOMEPAGE="http://www.semicomplete.com/projects/keynav/"
SRC_URI="http://semicomplete.googlecode.com/files/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-proto/xproto"
DEPEND="${RDEPEND}
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXext
	x11-libs/libXtst"

src_prepare() {
	epatch "${FILESDIR}/${P}_etc-config.patch"
	epatch "${FILESDIR}/${P}_fix-makefile.patch"
}

src_install() {
	dodoc README CHANGELIST
	dobin keynav
	insinto /etc
	doins keynavrc
}
