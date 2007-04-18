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

DEPEND="dev-util/pkgconfig
	media-libs/hamlib
	>=x11-libs/gtk+-2.6.0
	dev-libs/libxml2
	gnome-base/libgnomeprint"
RDEPEND="${DEPEND}"

src_compile() {
	# mime-update causes file collisions if enabled
	econf --enable-mime-update=no
	emake || die "emake failed!"
}

src_install() {
	emake install DESTDIR=${D} || die "emake install failed!"
	dodoc "${S}/README"
}
