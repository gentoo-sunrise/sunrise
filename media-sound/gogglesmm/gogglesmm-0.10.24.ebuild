# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base

DESCRIPTION="Lightweight FOX music collection manager and player"
HOMEPAGE="http://gogglesmm.googlecode.com/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="asf dbus mp4 old-miniplayer"

RDEPEND="dev-db/sqlite
	media-libs/taglib[asf?,mp4?]
	media-libs/xine-lib
	net-misc/curl
	x11-libs/fox[png]
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's:icons/hicolor/48x48/apps:pixmaps:' Makefile || die
}

src_configure() {
	# using old-miniplayer as USE flag, as the 'new remote' is not remote
	econf $(use_with asf) \
		$(use_with dbus) \
		$(use_with mp4) \
		$(use_with !old-miniplayer new-remote)
}
