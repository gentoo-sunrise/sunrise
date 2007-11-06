# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An amateur radio logging program"
HOMEPAGE="http://pg4i.chronos.org.uk/"
SRC_URI="http://pg4i.chronos.org.uk/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/hamlib
	=dev-libs/glib-2*
	>=x11-libs/gtk+-2.12
	>=gnome-base/libgnomeprint-2.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	# mime-update causes file collisions if enabled
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README
}
