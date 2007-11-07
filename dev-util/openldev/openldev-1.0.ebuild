# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Graphical front-end to various Development tools such as gcc."

HOMEPAGE="http://www.openldev.org/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
SRC_URI="http://kent.dl.sourceforge.net/sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
LICENSE="GPL-2"
S=${WORKDIR}/${PN}

DEPEND=">=x11-libs/gtk+-2.10.0
		>=x11-libs/gtksourceview-1.1.1
		>=gnome-base/gnome-vfs-2.0
		x11-libs/vte
		>=gnome-base/libglade-2.0
		dev-libs/libxml2
		>=gnome-base/libgnomeprint-2.2
		>=gnome-base/libgnomeprintui-2.2
		>=gnome-base/gconf-2.0
		>=gnome-base/libgnomeui-2.0
		x11-terms/gnome-terminal"
RDEPEND="${DEPEND}"

src_install() {
	 emake  DESTDIR="${D}" install || die
}

pkg_postinst() {
	einfo
	einfo "                  OpenLDev - ${HOMEPAGE}"
	einfo "OpenLDev is a graphical front-end to various Linux development tools"
	einfo "such as gcc, autotools and make. Most Integrated Development "
	einfo "Environments (IDE), are cumbersome and confusing to use, but "
	einfo "OpenLDev strives to provide an easy-to-use interface that is both"
	einfo "productive for experts and simple for beginners."
	einfo
}
