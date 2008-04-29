# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="http://rofi.roger-ferrer.org/eiciel/"
SRC_URI="http://rofi.roger-ferrer.org/eiciel/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls xattr"

RDEPEND=">=sys-apps/acl-2.2.32
	>=dev-cpp/gtkmm-2.8.1
	>=gnome-base/libgnome-2.10
	>=gnome-base/libgnomeui-2.10
	>=gnome-base/gnome-vfs-2.10
	>=gnome-base/nautilus-2.12.2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( >=sys-devel/gettext-0.15 )"

src_compile() {
	econf \
		$(use_enable xattr user-attributes) \
		$(use_enable nls) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
