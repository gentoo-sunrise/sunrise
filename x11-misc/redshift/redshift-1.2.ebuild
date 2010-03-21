# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base gnome2-utils

DESCRIPTION="Redshift adjusts screen's color temperature according to daytime"
HOMEPAGE="http://jonls.dk/redshift/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND="x11-libs/libX11[xcb]
	x11-libs/libXxf86vm
	x11-libs/libxcb
	sys-devel/gettext
	gtk? ( dev-python/pygtk )"
RDEPEND="${DEPEND}"
DOCS=( "README" "NEWS" "AUTHORS" "ChangeLog" )

src_configure() {
	econf --enable-randr \
		--enable-vidmode \
		$(use_enable gtk)
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
