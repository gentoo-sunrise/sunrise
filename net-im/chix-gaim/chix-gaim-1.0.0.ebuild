# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/-/_}

DESCRIPTION="a chikka gaim plugin"
HOMEPAGE="http://chix.sourceforge.net"
SRC_URI="mirror://sourceforge/chix/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-im/gaim-1.2.1
	=net-libs/chix-1.0.0"

S=${WORKDIR}/${MY_P}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README FAQ
}
