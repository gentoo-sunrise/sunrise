# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV=${PV/./}

DESCRIPTION="PVS (Potentially Visible Set) builder designed to be used with OpenGL ports of the DOOM game engine."
HOMEPAGE="http://www.vavoom-engine.com/glvis.php"
SRC_URI="mirror://sourceforge/vavoom/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_compile() {
	econf $(use_enable debug)
	emake || die "emake failed"
}

src_install() {
	dobin ${PN} || die "dobin failed"
	dodoc ${PN}.txt || die "dodoc failed"
}
