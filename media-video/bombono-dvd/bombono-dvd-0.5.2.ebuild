# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base toolchain-funcs

DESCRIPTION="GUI DVD authoring program"
HOMEPAGE="http://www.bombono.org/"
SRC_URI="mirror://sourceforge/bombono/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8
	>=dev-cpp/gtkmm-2.4
	>=media-gfx/graphicsmagick-1.1.7
	>=media-video/mjpegtools-1.8.0
	media-libs/libdvdread
	media-video/dvdauthor
	app-cdr/dvd+rw-tools
	media-sound/twolame
	dev-cpp/libxmlpp"

DEPEND=">=dev-util/scons-0.96.1
	${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-twolame.patch" )

src_compile() {
	# scons uses -l differently -> remove it
	scons CXX="$(tc-getCXX)" ${MAKEOPTS/-l[0-9]} DESTDIR="${D}" PREFIX="/usr" \
		|| die 'Please add "${S}/scons.config" when filing bugs reports!'
}

src_install() {
	scons install || die
}

