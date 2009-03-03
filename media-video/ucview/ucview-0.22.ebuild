# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Image capture application based on unicap"
HOMEPAGE="http://unicap-imaging.org/"
SRC_URI="http://unicap-imaging.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

DEPEND=">=gnome-base/gconf-2.0
	media-libs/alsa-lib
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/unicap[alsa,theora]
	>=x11-libs/gtk+-2.8"
RDEPEND=${DEPEND}

src_configure() {
	econf $(use_enable dbus)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
