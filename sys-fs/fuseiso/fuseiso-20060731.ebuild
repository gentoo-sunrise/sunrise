# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="FUSE module to mount ISO9660 images"
SRC_URI="http://ubiz.ru/dm/${P}.tar.bz2"
HOMEPAGE="http://fuse.sourceforge.net/wiki/index.php/FuseIso"
LICENSE="GPL-2"
DEPEND=">=sys-fs/fuse-2.2.1
	>=dev-libs/glib-2.4.2"
KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README NEWS ChangeLog AUTHORS
}

