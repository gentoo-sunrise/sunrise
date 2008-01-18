# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Framework for interactive GUI programming"
HOMEPAGE="http://felixrabe.textdriven.com/pygtk-shell/"
SRC_URI="http://felixrabe.textdriven.com/${PN}/releases/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""
RDEPEND=">=dev-python/pygtk-2.8
	dev-python/pycairo"

src_install() {
	distutils_src_install
	make_desktop_entry pygtk_shell.py "PyGTK Shell" " " "System;Shell"
	echo "OnlyShowIn=GNOME;KDE;XFCE;" >> "${D}"/usr/share/applications/*.desktop
}
