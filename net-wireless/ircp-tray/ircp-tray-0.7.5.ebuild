# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit gnome2-utils versionator

DESCRIPTION="A tray app for wireless OBEX file transfers using IrDA"
HOMEPAGE="https://launchpad.net/ircp-tray"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openobex
	x11-libs/gtk+:2
	x11-libs/libnotify"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

src_install( ) {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS CONTRIBUTORS ChangeLog || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}
