# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="BitTorrent client in Python and PyGTK."
HOMEPAGE="http://deluge.ath.cx/"
SRC_URI="http://deluge.mynimalistic.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/${PN}-0.3"

DEPEND="net-libs/rb_libtorrent
	>dev-lang/python-2.3
	dev-libs/boost
	=dev-python/pygtk-2*
	dev-python/python-libtorrent"
RDEPEND="${DEPEND}"

src_install() {
	dodir "/usr/$(get_libdir)/${PN}"
	insinto "/usr/$(get_libdir)/${PN}"
	doins -r *.py po glade pixmaps po

	newicon pixmaps/deluge-32.png deluge.png
	make_wrapper ${PN} "/usr/bin/python /usr/lib/${PN}/deluge.py"
	make_desktop_entry ${PN} deluge

	dodoc ChangeLog README
}
