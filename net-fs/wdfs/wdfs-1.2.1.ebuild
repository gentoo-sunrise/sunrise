# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="WebDAV filesystem with special features for accessing subversion repositories"
HOMEPAGE="http://noedler.de/projekte/wdfs/"
SRC_URI="http://noedler.de/projekte/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=net-misc/neon-0.24.7
	 >=sys-fs/fuse-2.3"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog AUTHORS NEWS README
}
