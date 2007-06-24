# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A Gnome tray app for wireless OBEX file transfer using IRDA or Bluetooth"
HOMEPAGE="http://gro.clinux.org/projects/ircp-tray/"
# download directory varies release by release
SRC_URI="http://gro.clinux.org/frs/download.php/2011/ircp-tray-0.7.2.1.tar.gz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6.0
	>=gnome-base/libgnome-1.96.0
	>=gnome-base/libgnomeui-1.96.0
	>=dev-libs/openobex-1.0"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=app-text/scrollkeeper-0.1.4
	dev-util/pkgconfig"

src_compile() {
	econf --with-posix-regex || die "econf failed"
	emake || die "emake failed"
}

src_install( ) {
	emake DESTDIR="${D}" install || die
	dodoc README CHANGES
}
