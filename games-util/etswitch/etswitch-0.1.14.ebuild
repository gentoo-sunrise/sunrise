# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A 'minimizer' for a few games."
HOMEPAGE="http://hem.bredband.net/b400150/"
SRC_URI="http://hem.bredband.net/b400150/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXxf86vm
	x11-libs/libXt
	x11-libs/libXpm"

src_compile() {
	econf \
		$(use_enable debug) || die "econf failed."
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
