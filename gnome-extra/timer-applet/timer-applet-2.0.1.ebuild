# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit gnome2 python multilib

DESCRIPTION="A countdown timer applet for the GNOME panel"
HOMEPAGE="http://timerapplet.sourceforge.net"
SRC_URI="mirror://sourceforge/timerapplet/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc sounds libnotify"

DEPEND="|| ( ( virtual/python:2.4 dev-python/elementtree )
		virtual/python:2.5 )
	>=dev-python/pygtk-2.10
	>=dev-python/gnome-python-2.16
	>=dev-python/gnome-python-desktop-2.16
	>=dev-python/notify-python-0.1
	>=dev-python/dbus-python-0.8"
RDEPEND="${DEPEND}"

DOCS="AUTHORS Changelog NEWS README"

src_unpack() {
	gnome2_src_unpack
	ln -sf $(type -P true) "${S}/py-compile"
}

pkg_postinst() {
	python_version
	python_mod_optimize "/usr/$(get_libdir)/python${PYVER}/site-packages/timerapplet"
}

pkg_postrm() {
	python_version
	python_mod_cleanup "/usr/$(get_libdir)/python${PYVER}/site-packages/timerapplet"
}
