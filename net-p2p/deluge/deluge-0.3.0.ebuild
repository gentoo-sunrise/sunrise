# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="BitTorrent client in Python and PyGTK."
HOMEPAGE="http://zachtib.googlepages.com/deluge/"
SRC_URI="http://zachtib.googlepages.com/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}

DEPEND="net-libs/rb_libtorrent
	>dev-lang/python-2.3
	dev-libs/boost
	>=dev-python/pygtk-2*
	dev-python/python-libtorrent"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/lib/deluge
	insinto /usr/lib/deluge
	doins -r *

	make_wrapper deluge "/usr/bin/python /usr/lib/${PN}/deluge.py"
}
