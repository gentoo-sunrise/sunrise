# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="nls gnome"

DESCRIPTION="Control and configure somad through somax, a graphic panel"
HOMEPAGE="http://www.somasuite.org"
SRC_URI="http://www.somasuite.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-sound/soma
	>=x11-libs/gtk+-2.0
	x11-libs/libSM
	x11-libs/vte
	gnome? ( x11-libs/gtksourceview )
	gnome? ( >=gnome-base/libgnomeprintui-2.0 )"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gtksourceview_env.patch
}

src_compile() {
	if ! use gnome;then
	        myconf="${myconf} --disable-gnomeprint"
	fi

	econf \
		$(use_enable nls) \
		$(use_enable gnome) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"

	doicon icons/somax.png
	make_desktop_entry somax SomaX somax.png AudioVideo 

	dodoc AUTHORS ChangeLog ABOUT-NLS README README.modules README.plugins README.library
}

pkg_postinst() {
	einfo " *** *** ***"
	einfo "If you can afford to donate us some money let us know, we also need"
	einfo "new and old working hardware."
	einfo " "
	einfo "you can send a mail to"
	einfo " "
	einfo " mail: soma@inventati.org"
	einfo "  or: bakunin@autistici.org"
	einfo " *** *** ***"
}

