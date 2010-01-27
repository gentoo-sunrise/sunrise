# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="VoriaETL is a multiplatform class and template library designed to complement and supplement the C++ STL"

HOMEPAGE="http://www.synfig.com/"

SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
}
