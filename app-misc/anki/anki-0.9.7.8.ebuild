# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4
inherit eutils multilib python

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="http://ichi2.net/anki/index.html"
SRC_URI="http://ichi2.net/anki/download/${P}.tgz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graph kakasi sound"

RDEPEND=">=dev-python/PyQt4-4.3
	>=dev-python/sqlalchemy-0.4.1
	>=dev-python/simplejson-1.7.3
	>=dev-python/pysqlite-2.3.0
	app-text/dvipng
	graph? (
		dev-python/numpy
		>=dev-python/matplotlib-0.91.2
	)
	sound? ( dev-python/pygame )
	kakasi? ( app-i18n/kakasi )"

src_install() {
	dodoc CREDITS

	python_version

	insinto "/usr/$(get_libdir)/python${PYVER}/site-packages"
	doins -r ankiqt libanki/anki

	insinto "/usr/$(get_libdir)/python${PYVER}/site-packages/anki"
	doins -r designer icons icons.qrc icons_rc.py libanki/samples

	dobin ${PN}

	doicon icons/${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}.png "Education"
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/ankiqt
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/anki

	if use x86 && ! has_version dev-python/psyco; then
		elog "Installing dev-python/psyco is strongly recommended."
	fi
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/ankiqt
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/anki
}
