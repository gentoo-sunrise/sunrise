# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P}-1"

DESCRIPTION="Create BitTorrent files easily"
HOMEPAGE="http://claudiusmaximus.goto10.org/index.php?page=coding/buildtorrent"
SRC_URI="http://claudiusmaximus.goto10.org/files/coding/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}
