# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="FUSE based filesystem for gphoto2"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">media-libs/libgphoto2-2.4.0
		>=dev-libs/glib-2.6
		>=sys-fs/fuse-2.5"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
}
