# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Pinux's Tux Cursors Theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=19506"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/19506-pinux's-tux-cursors-theme-${PV}-cur.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto "/usr/share/cursors/xorg-x11/"
	doins -r "cursors/"* || die "cannot install cursor themes"

	dodoc "README" || die "cannot install documentation"
}

pkg_postinst() {
	einfo "To use this set of cursors, edit or create the file ~/.Xdefaults"
	einfo "and add the following line:"
	einfo "Xcursor.theme: themeName"
	einfo "where \"themeName\" is any of the installed themes."
	einfo "Alternatively, use the configuration tool of your desktop environment."
}
