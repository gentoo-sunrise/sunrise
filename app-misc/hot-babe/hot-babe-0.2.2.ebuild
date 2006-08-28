# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Displays the system activity in a very special way ;-)"
HOMEPAGE="http://dindinx.net/hotbabe/"
SRC_URI="http://dindinx.net/hotbabe/downloads/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE="offensive"

DEPEND=">=x11-libs/gtk+-2.0
	media-libs/gdk-pixbuf"
RDEPEND="${DEPEND}"

pkg_setup() {
	use offensive || die "You need USE=offensive to emerge"
}

src_compile() {
	emake CC=$(tc-getCC) PREFIX="/usr" || die "emake failed"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "install failed"
	newman "${D}/usr/share/man/man1/${PN}.1" ${PN}.6
}
