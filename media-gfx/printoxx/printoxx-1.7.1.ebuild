# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Program for printing one or more image files with a user-defined page layout."
HOMEPAGE="http://kornelix.squarespace.com/printoxx"
SRC_URI="http://kornelix.squarespace.com/storage/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_compile() {
	emake PREFIX=/usr || die "build failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install || die "emake install failed"
	make_desktop_entry ${PN} "Printoxx" /usr/share/${PN}/icons/${PN}.png "Application;Graphics;2DGraphics;"
}
