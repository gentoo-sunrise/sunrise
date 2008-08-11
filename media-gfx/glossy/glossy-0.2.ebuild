# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Glossy theme for gensplash consoles"
HOMEPAGE="http://www.kde-look.org/content/show.php/Gentoo+Glossy+Fbsplash+theme?content=84095"
SRC_URI="http://dev.gentoo.org/~coldwind/stuff/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RESTRICT="binchecks strip"

RDEPEND=">=media-gfx/splashutils-1.4.1"

src_install() {
	insinto /etc/splash/${PN}
	doins -r "${S}"/*
}
