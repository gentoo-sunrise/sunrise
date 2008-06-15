# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit subversion

DESCRIPTION="An open-source car navigation system with a routing engine."
HOMEPAGE="http://www.navit-project.org"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus garmin gps gtk nls python sdl speechd"

COMMON_DEPEND="dev-libs/glib:2
	garmin? ( dev-libs/libgarmin )
	gtk? ( x11-libs/gtk+:2
		x11-misc/xkbd )
	sdl? ( media-libs/libsdl
		media-libs/sdl-image
		>=dev-games/cegui-0.5
		media-libs/quesoglc )
	python? ( dev-lang/python )
	dbus? ( sys-apps/dbus )
	gps? ( sci-geosciences/gpsd )
	speechd? ( app-accessibility/speechd )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

ESVN_REPO_URI="https://navit.svn.sourceforge.net/svnroot/navit/trunk/navit"
ESVN_BOOTSTRAP="./autogen.sh"

src_compile() {
	econf $(use_enable garmin) \
		$(use_enable gps libgps) \
		$(use_enable gtk gui-gtk) \
		$(use_enable sdl gui-sdl) \
		$(use_enable nls) \
		$(use_enable dbus binding-dbus) \
		$(use_enable python binding-python) \
		$(use_enable speechd speech-speechd) \
		--disable-graphics-qt-painter \
		--disable-samplemap

	emake || die "Make failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "Install failed"
}
