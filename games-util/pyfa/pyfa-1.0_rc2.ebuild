# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"

inherit eutils python

FOLDER="stable"
if [[ ${PV/_rc*/} == ${PV} ]] ; then
	MY_PV=${PV}-stable-src
else
	MY_PV=${PV/_rc/-stable-RC}-src
	FOLDER+=/${PV/*_rc/RC}
fi

DESCRIPTION="Python Fitting Assistant - a ship fitting application for EVE Online"
HOMEPAGE="http://www.evefit.org/Pyfa"
SRC_URI="http://dl.evefit.org/${FOLDER}/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-3 LGPL-2.1 CCPL-Attribution-2.5 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+graph"

RDEPEND="dev-python/sqlalchemy
	>=dev-python/wxpython-2.8
	graph? ( dev-python/matplotlib[wxwidgets] dev-python/numpy )"
DEPEND=${RDEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	python_convert_shebangs -r -x 2 .
	sed -e "s:%%SITEDIR%%:$(python_get_sitedir):" -e "s:%%EROOT%%:${EROOT}:" \
		"${FILESDIR}/configforced.py" > configforced.py
}

src_install() {
	local packagedir=$(python_get_sitedir)/${PN}
	insinto "${packagedir}"
	doins -r eos gui icons service config*.py info.py gpl.txt || die "doins failed"
	exeinto "${packagedir}"
	doexe ${PN}.py || die "doexe failed"
	dosym "${packagedir}/${PN}.py" /usr/bin/${PN} || die "dosym failed"
	insinto /usr/share/${PN}
	doins -r staticdata || die "doins failed"
	dodoc readme.txt || die "dodoc failed"
	doicon icons/${PN}.png || die "doicon failed"
	domenu "${FILESDIR}/${PN}.desktop" || die "domenu failed"
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
