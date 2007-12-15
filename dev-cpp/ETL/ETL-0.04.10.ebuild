# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="VoriaETL is a multiplatform class and template library designed to
complement and supplement the C++ STL."

# currently :
# https://sourceforge.net/projects/synfig/
# http://www.deepdarc.com/2005/11/01/synfig-developer-preview/
HOMEPAGE="http://www.synfig.com"
SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
}
