# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Small GTK+ text editor"
HOMEPAGE="http://tea-editor.sourceforge.net"
SRC_URI="mirror://sourceforge/tea-editor/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ipv6 gnome"

RDEPEND=">=x11-libs/gtk+-2.2
	>=app-text/aspell-0.50.5
	gnome? ( >=x11-libs/gtksourceview-1.6.1 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
		$(use_enable ipv6 ) \
		$(use_enable !gnome legacy ) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	doicon ${FILESDIR}/tea.png
	make_desktop_entry tea Tea tea Office
}
