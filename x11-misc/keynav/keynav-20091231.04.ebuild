# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Make pointer-driven interfaces easier and faster for users to operate"
HOMEPAGE="http://www.semicomplete.com/projects/keynav/"
SRC_URI="http://semicomplete.googlecode.com/files/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXext
	x11-libs/libXtst
	x11-misc/xdotool"
DEPEND="x11-proto/xproto
	${RDEPEND}"

src_compile() {
	tc-export CC LD
	default
}

src_install() {
	dodoc README CHANGELIST || die "Unable to install documentation"
	dobin keynav || die "Unable to install keynav binary"
	insinto /etc
	doins keynavrc || die "Unable to install keynavrc"
}
