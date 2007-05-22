# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.7"
inherit gnome2 autotools

DESCRIPTION="Nautilus extension for adding user-configurable actions to the context menu"
HOMEPAGE="http://www.grumz.net/?q=taxonomy/term/2/9"
SRC_URI="ftp://ftp2.grumz.net/grumz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=dev-libs/glib-2.8
	>=x11-libs/gtk+-2.6.8
	>=gnome-base/libglade-2.4.0
	>=gnome-base/libgnome-2.7
	>=gnome-base/libgnomeui-2.7
	>=gnome-base/gconf-2.8
	>=dev-libs/libxml2-2.6
	>=gnome-base/nautilus-2.8"
DEPEND=">=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.9.0
	${RDEPEND}"

DOCS="AUTHORS ChangeLog MAINTAINERS README TODO"

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Some functionality in this version will only be available under"
	elog ">=nautilus-2.16.0. See http://www.grumz.net/index.php?q=node/264 for more info."
	elog "If you want this functionality under =nautilus-2.14* you need to rebuild"
	elog "Nautilus first with the following patch:"
	elog "http://bugzilla.gnome.org/attachment.cgi?id=67484&action=view"
}
