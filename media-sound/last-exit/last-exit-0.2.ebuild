# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"
inherit mono gnome2 eutils

DESCRIPTION="Gnome/GTK+ alternative to the last.fm player"
HOMEPAGE="http://www.o-hand.com/~iain/last-exit/"
SRC_URI="http://www.o-hand.com/~iain/last-exit/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=gnome-base/gconf-2.0
		>=x11-libs/gtk+-2.6
		sys-libs/zlib
		>=media-libs/gstreamer-0.10.0
		>=dev-lang/mono-1.0
		>=dev-dotnet/gtk-sharp-1.9.2
		>=dev-dotnet/gnome-sharp-1.9.2
		>=dev-dotnet/glade-sharp-1.9.2
		>=dev-dotnet/gconf-sharp-1.9.2"

RDEPEND="${DEPEND}
		>=media-libs/gst-plugins-base-0.10.0
		>=media-plugins/gst-plugins-gnomevfs-0.10.0
		>=media-plugins/gst-plugins-gconf-0.10.0
		>=media-plugins/gst-plugins-mad-0.10.0"


pkg_setup() {
	G2CONF="${G2CONF} \
	--disable-schemas-install"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Sorry, this patch is NOT publically available
	# epatch "${FILESDIR}/${PN}-save-song.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "parallel install failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}