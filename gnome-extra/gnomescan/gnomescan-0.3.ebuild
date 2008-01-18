# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="The Gnome Scan project aim to provide scan features every where in the desktop like print is."
HOMEPAGE="http://home.gna.org/gnomescan/index"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="pdf doc"

RDEPEND=">=x11-libs/gtk+-2.8
	media-gfx/sane-backends
	>=dev-libs/glib-2.4
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=x11-libs/cairo-1.2
	>=app-text/scrollkeeper-0.3.14
	>=media-gfx/gimp-2.2"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	dev-util/pkgconfig"

DOCS="AUTHORS NEWS README TODO"

pkg_setup(){
	G2CONF="${G2CONF} $(use_enable pdf)"
}
