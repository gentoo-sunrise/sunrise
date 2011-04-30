# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils

DESCRIPTION="Simple DVD slideshow maker"
HOMEPAGE="http://imagination.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	x11-libs/gtk+:2
	media-sound/sox"
RDEPEND="${DEPEND}
	media-video/ffmpeg"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_install() {
	default
	doicon icons/48x48/${PN}.png
}
