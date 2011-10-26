# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Pinux's Tux Cursors Theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=19506"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/19506-pinux's-tux-cursors-theme-${PV}-cur.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/cursors/xorg-x11/
	doins -r cursors/*
	dodoc "README"
}

pkg_postinst() {
	elog "To use this set of cursors, edit or create the file ~/.Xdefaults"
	elog "and add the following line:"
	elog "Xcursor.theme: themeName"
	elog "where \"themeName\" is any of the installed themes."
	elog "Alternatively, use the configuration tool of your desktop environment."
}
