# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Lightweight FOX music collection manager and player"
HOMEPAGE="http://gogglesmm.googlecode.com/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="asf dbus gcrypt mp4 old-miniplayer"

RDEPEND="dev-db/sqlite:3
	>=media-libs/taglib-1.6.3[asf?,mp4?]
	media-libs/xine-lib
	net-misc/curl
	x11-libs/fox[png]
	dbus? ( sys-apps/dbus )
	gcrypt? ( dev-libs/libgcrypt )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's:icons/hicolor/48x48/apps:pixmaps:' Makefile || die
}

src_configure() {
	if use gcrypt ; then
		extraconf="--with-md5=gcrypt"
	else
		extraconf="--with-md5=internal"
	fi

	# using old-miniplayer as USE flag, as the 'new remote' is not remote
	econf $extraconf \
		$(use_with dbus) \
		$(use_with !old-miniplayer new-remote)
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS README || die
}
