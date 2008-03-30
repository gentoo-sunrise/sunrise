# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git eutils

DESCRIPTION="A lightweight web browser"
HOMEPAGE="http://software.twotoasts.de/?page=midori"
EGIT_REPO_URI="http://software.twotoasts.de/media/midori.git"
EGIT_PROJECT="midori"
EGIT_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+
	x11-libs/libsexy
	net-libs/webkitgtk"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	# NEWS is empty, ChangeLog has TODO's body
	dodoc AUTHORS ChangeLog INSTALL TODO
}

