# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"
inherit gnome2 versionator

MY_PN="icons-xfce-gant"
MY_PV=$(replace_version_separator 2 '-' )

DESCRIPTION="The amazing Gant icon set for Xfce 4.x"
HOMEPAGE="http://www.xfce-look.org/content/show.php/GANT?content=23297"
SRC_URI="http://overlay.uberpenguin.net/${MY_PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/Gant.Xfce

src_compile() {
	einfo "Nothing to compile, installing..."
}

src_install() {
	rm -f README
	insinto /usr/share/icons/Gant.Xfce
	doins -r *
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
