# Copyright 1999-2011 Gentoo Foundation
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
IUSE="dbus gcrypt"

RDEPEND="dev-db/sqlite:3
	media-libs/taglib
	media-libs/xine-lib
	net-misc/curl
	x11-libs/fox[png]
	dbus? ( sys-apps/dbus )
	gcrypt? ( dev-libs/libgcrypt )"
DEPEND="${RDEPEND}"

DOCS=(AUTHORS README)
# Upstream patch to fix parallel builds. Won't be needed >=0.12.3
PATCHES=( "${FILESDIR}/${PN}-parallel-make.patch" )

src_prepare() {
	# Note: Makefile is NOT affected by ./configure
	sed -i -e 's:icons/hicolor/48x48/apps:pixmaps:' Makefile || die

	base_src_prepare
}

src_configure() {

	local myeconfargs=( $(use_with dbus) )

	if use gcrypt ; then
		myeconfargs+=("--with-md5=gcrypt")
	else
		myeconfargs+=("--with-md5=internal")
	fi

	base_src_configure "${myeconfargs[@]}"
}

pkg_postinst() {
	elog "For asf and/or mp4 tag support, build "
	elog "    media-libs/taglib with USE='asf mp4'"
}
