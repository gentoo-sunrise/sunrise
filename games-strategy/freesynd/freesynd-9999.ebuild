# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils subversion games

DESCRIPTION="A cross-platform reimplementation of engine for the classic Bullfrog game, Syndicate"
HOMEPAGE="http://freesynd.sourceforge.net/"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/${PN}/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-libs/libogg
	media-libs/libpng:0
	media-libs/libsdl[X,audio,video]
	media-libs/libvorbis
	media-libs/sdl-mixer[mp3,vorbis]
	media-libs/sdl-image[png]"
DEPEND="${RDEPEND}"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	sed \
		-e "/freesynd_data_dir/s#/usr/share#${GAMES_DATADIR}#" \
		-e "/freesynd_data_dir/s/#//" \
		-i ${PN}.ini || die
}

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	dogamesbin src/${PN} || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data || die
	newicon icon/sword.png ${PN}.png || die
	make_desktop_entry ${PN} ${PN} ${PN}
	dodoc NEWS README INSTALL AUTHORS || die
}

pkg_postinst() {
	games_pkg_postinst
	elog "You have to set \"data_dir = /my/path/to/synd-data\""
	elog "in \"~/.${PN}/${PN}.ini\"."
}
