# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 

DESCRIPTION="Bonfire is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://perso.wanadoo.fr/bonfire/" 
SRC_URI="mirror://sourceforge/bonfire/${P}.tar.bz2" 

LICENSE="GPL-2" 
SLOT="0" 
KEYWORDS="~x86"
IUSE="beagle totem nls"

# See bug 137799 why optional dependency of dev-lang/gdl is not here yet.

RDEPEND="|| ( ( x11-libs/libXrandr
		x11-libs/libXcursor
		x11-libs/libXrender
		x11-libs/libXext
		x11-libs/libXfixes )
		virtual/x11 )
	>=x11-libs/gtk+-2.8.8
	>=gnome-base/libgnome-2.14 
	>=gnome-base/libgnomeui-2.14 
	>=gnome-base/gnome-vfs-2.14.2 
	>=media-libs/gstreamer-0.10.6 
	>=sys-apps/hal-0.5 
	>=sys-apps/dbus-0.5
	>=gnome-extra/nautilus-cd-burner-2.14
	>=dev-libs/libxml2-2.6
	totem? ( >=media-video/totem-1.4 )
	beagle? ( >=app-misc/beagle-0.2.5 )
	>=x11-libs/libnotify-0.3" 

DEPEND="${RDEPEND} 
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool"

G2CONF="${G2CONF} \
	$(use_enable totem playlist) \
	$(use_enable beagle search)"

src_install() {
        gnome2_src_install
        use nls || rm -rf ${D}/usr/share/locale
}

DOCS="ChangeLog NEWS README MAINTAINERS"
USE_DESTDIR="1"
