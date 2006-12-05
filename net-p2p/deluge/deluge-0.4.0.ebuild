# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python multilib

DESCRIPTION="BitTorrent client in Python and PyGTK."
HOMEPAGE="http://deluge-torrent.org/"
SRC_URI="http://deluge.mynimalistic.net/downloads/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}

DEPEND=">=dev-lang/python-2.3
	dev-libs/boost
	>=dev-python/pygtk-2
	=dev-python/python-libtorrent-${PV}
	dev-python/pyxdg"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A} && cd "${S}"
	# remove .svn dirs
	rm -rf */.svn
}

src_install() {
	python_version
	insinto "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
	doins -r *.py po/ glade/ pixmaps/ plugins/

	newicon pixmaps/${PN}-32.png ${PN}.png
	make_wrapper ${PN} "${ROOT}usr/bin/python ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/${PN}.py"
	make_desktop_entry ${PN} ${PN}

	dodoc Changelog README
}
pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}

pkg_postrm() {
	python_version
	python_mod_cleanup "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}
