# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Control Center module for editing your ~/.kde/Autostart entries"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=45975"
SRC_URI="http://ftp.nluug.nl/pub/os/Linux/distr/pardusrepo/sources/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

need-kde 3.5

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
