# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Gnome OSD notification system"
HOMEPAGE="http://www.gnomefiles.org/app.php?soft_id=350"
SRC_URI="http://telecom.inescporto.pt/~gjc/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc dbus"

RDEPEND=">=dev-lang/python-2.3.0
	>=dev-python/pygtk-2.4.0
	>=dev-python/gnome-python-2.6.0
	dbus? ( dev-python/dbus-python )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_postinst() {
	gnome2_pkg_postinst

	# see the Installation section of the README
	kill -s HUP `pidof gconfd-2` > /dev/null 2>&1 || true
}
