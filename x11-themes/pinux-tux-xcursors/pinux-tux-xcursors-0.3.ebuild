# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Pinux's Tux Cursors Theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=19506"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/19506-pinux's-tux-cursors-theme-${PV}-cur.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND=""

# cursor themes to be installed
THEMES="pCircle-24 pCircle-32 pDebian-24 pDebian-32 pGentoo-24 \
	pGentoo-32 pSlackware-24 pSlackware-32 pSuse-24 pSuse-32 pTux-24 pTux-32 \
	pUbuntu-24 pUbuntu-32"

# are there other implementations?
X11_IMPLEM="xorg-x11"

src_install() {
	for cursortheme in ${THEMES} ; do
		dodir "/usr/share/cursors/${X11_IMPLEM}/${cursortheme}/"
		for cursorfile in index.theme cursors ; do
			cp -dr "${WORKDIR}/cursors/${cursortheme}/${cursorfile}" \
			"${D}usr/share/cursors/${X11_IMPLEM}/${cursortheme}/" || die
		done
	done
	dodoc "${WORKDIR}/README"
}

pkg_postinst() {
	einfo "The following cursor themes have been installed:"
	for cursortheme in ${THEMES} ; do
		einfo "  ${cursortheme}"
	done
	einfo ""
	einfo "To use this set of cursors, edit or create the file ~/.Xdefaults"
	einfo "and add the following line:"
	einfo "Xcursor.theme: pTux24"
	einfo "Alternatively, use KDE's control center to switch to this set"
	einfo "of cursors."
	einfo ""
	einfo "Also, to globally use this set of mouse cursors edit the file:"
	einfo "   /usr/local/share/cursors/${X11_IMPLEM}/default/index.theme"
	einfo "and change the line:"
	einfo "    Inherits=[current setting]"
	einfo "to"
	einfo "    Inherits=pTux24"
	einfo ""
	einfo "Note this will be overruled by a user's ~/.Xdefaults file."
	einfo ""
	ewarn "If you experience flickering, try setting the following line in"
	ewarn ""
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option  \"HWCursor\"  \"false\""
}
