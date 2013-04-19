# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Pidgin plugin for sharing and viewing links to videos"
HOMEPAGE="http://code.google.com/p/pidgin-embeddedvideo/"
SRC_URI="http://pidgin-embeddedvideo.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin[gtk]
	>=net-libs/webkit-gtk-1.1.12
	net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_configure() {
	# due to configure.ac line 35
	econf --prefix="NONE"
}
