# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Control and configure soma through a graphic panel"
HOMEPAGE="http://www.somasuite.org/"
SRC_URI="http://www.somasuite.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls gnome"

RDEPEND="
	media-sound/soma
	x11-libs/gtk+:2
	x11-libs/libSM
	x11-libs/vte:0
	gnome? (
		x11-libs/gtksourceview:2.0
		gnome-base/libgnomeprintui:2.2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog README README.{modules,plugins,library}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gtksourceview_env.patch
}

src_configure() {
	use gnome || myconf="${myconf} --disable-gnomeprint"

	econf \
		$(use_enable nls) \
		$(use_enable gnome) \
		${myconf}
}

src_install() {
	default

	doicon icons/somax.png
	make_desktop_entry ${PN} SomaX ${PN}.png AudioVideo;GTK
}

pkg_postinst() {
	einfo "If you can afford to donate us some money let us know, we also need"
	einfo "new and old working hardware."
	einfo
	einfo "you can send a mail to"
	einfo
	einfo " mail: soma@inventati.org"
	einfo "  or: bakunin@autistici.org"
}
