# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit fdo-mime

DESCRIPTION="A multi-paned tabbed file manager"
HOMEPAGE="http://spacefm.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

COMMON_DEPEND="dev-libs/glib:2
	dev-util/desktop-file-utils
	sys-apps/dbus
	x11-libs/gtk+:2
	x11-libs/startup-notification"
RDEPEND="${COMMON_DEPEND}
	virtual/freedesktop-icon-theme
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/pango
	x11-misc/shared-mime-info"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

src_configure() {
	econf --disable-hal
}

pkg_postinst() {
	elog "SpaceFM supports udisks if installed"
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
