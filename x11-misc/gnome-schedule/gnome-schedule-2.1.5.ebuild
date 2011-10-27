# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"

inherit python gnome2

DESCRIPTION="GUI to aid users configuring the crontab and at daemons"
HOMEPAGE="http://gnome-schedule.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet"

RDEPEND="
	x11-libs/gtk+:2
	gnome-base/gconf:2
	dev-libs/glib:2
	>=dev-python/pygtk-2.6
	virtual/cron
	sys-process/at
	>=dev-python/gnome-python-2.12.0
	>=app-text/gnome-doc-utils-0.3.2
	app-text/rarian"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.28"

DOCS="AUTHORS NEWS README TODO"

pkg_setup () {
	python_set_active_version 2
	G2CONF="${G2CONF}
		$(use_enable applet)"
}
