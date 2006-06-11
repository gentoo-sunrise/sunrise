# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Portage analysis toolkit"
HOMEPAGE="http://catmur.co.uk/gentoo/udept"
SRC_URI="http://catmur.co.uk/~ed/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

RDEPEND="sys-apps/portage"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
