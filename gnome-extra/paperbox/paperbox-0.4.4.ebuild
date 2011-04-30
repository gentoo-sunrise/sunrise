# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2 versionator

MY_PVM=$(get_version_component_range 1-2)

DESCRIPTION="Browse your documents, ebooks and magazines and organize them with tags using Tracker"
HOMEPAGE="http://live.gnome.org/PaperBox/"
SRC_URI="mirror://gnome/sources/${PN}/${MY_PVM}/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-misc/tracker
	app-text/scrollkeeper
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-cpp/gtkmm-utils
	dev-cpp/libglademm:2.4
	dev-libs/boost
	dev-libs/dbus-glib
	gnome-base/libgnomeui
	x11-libs/goocanvas"
DEPEND="
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README"
