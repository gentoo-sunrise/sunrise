# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

DESCRIPTION="Dragbox is a GTK tool for connecting the commandline with the desktop environment."
HOMEPAGE="http://kaizer.se/wiki/dragbox/"
SRC_URI="http://kaizer.se/publicfiles/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/pygtk
	gnome-base/libglade
	sys-apps/dbus
	x11-libs/gtk+"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/Dragbox
}

pkg_postrm() {
	python_mod_cleanup $(python_get_sitedir)/Dragbox
}
