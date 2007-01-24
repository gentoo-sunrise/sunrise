# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python multilib

DESCRIPTION="BitTorrent client in Python and PyGTK."
HOMEPAGE="http://deluge-torrent.org/"
SRC_URI="http://deluge-torrent.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

DEPEND=">=dev-lang/python-2.3
	dev-libs/boost
	>=dev-python/pygtk-2
	~dev-python/python-libtorrent-0.4.0
	dev-python/pyxdg
	libnotify? ( dev-python/notify-python )"
RDEPEND="${DEPEND}"

src_install() {
	python_version
	insinto "/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
	doins -r *.py glade/ pixmaps/ plugins/

	newicon pixmaps/${PN}-32.png ${PN}.png
	make_wrapper ${PN} "/usr/bin/python /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/${PN}.py"
	make_desktop_entry ${PN} ${PN}

	dodoc README
}
pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}

pkg_postrm() {
	python_version
	python_mod_cleanup "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}
