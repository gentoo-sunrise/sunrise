# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="nls gnome"

DESCRIPTION="Control and configure soma through a graphic panel"
HOMEPAGE="http://www.somasuite.org"
SRC_URI="http://www.somasuite.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-sound/soma
	>=x11-libs/gtk+-2.0
	x11-libs/libSM
	x11-libs/vte
	gnome? ( x11-libs/gtksourceview
		>=gnome-base/libgnomeprintui-2.0 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gtksourceview_env.patch
}

src_compile() {
	use gnome || myconf="${myconf} --disable-gnomeprint"

	econf \
		$(use_enable nls) \
		$(use_enable gnome) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	doicon icons/somax.png
	make_desktop_entry ${PN} SomaX ${PN}.png AudioVideo;GTK

	dodoc AUTHORS ChangeLog README README.{modules,plugins,library}
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
