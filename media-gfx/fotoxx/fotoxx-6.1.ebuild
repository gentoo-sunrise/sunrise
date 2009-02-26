# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Program for improving image files made with a digital camera."
HOMEPAGE="http://kornelix.squarespace.com/fotoxx"
SRC_URI="http://kornelix.squarespace.com/storage/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8
	media-libs/freeimage"
RDEPEND="${DEPEND}
	media-gfx/exiv2
	media-gfx/ufraw
	media-gfx/printoxx"

src_unpack() {
	unpack ${A}

	cd "${PN}"

	# Dynamically link freeimage instead of statically doing it.
	sed -i \
		-e "s:gthread-2.0\`:gthread-2.0\` -lfreeimage:" \
		-e "s:libfreeimage\.a::" Makefile || die "sed Makefile failed"
}

S=${WORKDIR}/${PN}

src_compile() {
	emake PREFIX=/usr || die "build failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install || die "emake install failed"
	make_desktop_entry ${PN} "Fotoxx" /usr/share/${PN}/icons/${PN}.png "Application;Graphics;2DGraphics;"
}
