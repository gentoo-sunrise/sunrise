# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
PYTHON_USE_WITH="sqlite"

inherit eutils python

if [[ ${PV/_rc*/} == ${PV} ]] ; then
	MY_PV=${PV}-stable-src
else
	MY_PV=${PV/_rc/-stable-RC}-src
fi

DESCRIPTION="Python Fitting Assistant - a ship fitting application for EVE Online"
HOMEPAGE="http://www.evefit.org/Pyfa"
SRC_URI="http://dl.evefit.org/stable/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-3 LGPL-2.1 CCPL-Attribution-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+graph"

RDEPEND="dev-python/sqlalchemy
	dev-python/wxpython
	graph? ( dev-python/matplotlib[wxwidgets] dev-python/numpy )"
DEPEND=${RDEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}/${P}-paths.patch"
}

src_install() {
	newbin run.py ${PN} || die "newbin failed"
	rm run.py
	insinto "$(python_get_sitedir)/${PN}"
	doins -r eos gui icons service *.py *.txt || die "doins failed"
	insinto /usr/share/${PN}
	doins -r staticdata || die "doins failed"
	dodoc README || die "dodoc failed"
	doicon icons/${PN}.png || die "doicon failed"
	domenu "${FILESDIR}/${PN}.desktop" || die "domenu failed"
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
