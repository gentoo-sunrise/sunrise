# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="VoriaETL is a multiplatform class and template library which complements and supplements the C++ STL"

# currently :
# https://sourceforge.net/projects/synfig/
# http://www.deepdarc.com/2005/11/01/synfig-developer-preview/
HOMEPAGE="http://www.synfig.org"
SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
}
