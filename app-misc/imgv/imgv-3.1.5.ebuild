# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils multilib

MY_P="${P}-src"

DESCRIPTION="A unique and feature rich image viewer using Python"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://imgv.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk
	dev-python/pygame
	dev-python/imaging"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_install() {
	python_version
	INST_DIR="/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"

	insinto "${INST_DIR}"
	cd "${S}"
	doins -r *.py
	insinto "${INST_DIR}/data"
	cd "${S}/data"
	doins -r *

	cd "${S}"
	echo "IMGV_HOME=${INST_DIR}" >> 90imgv
	doenvd 90imgv

	make_wrapper imgv "/usr/bin/python ${INST_DIR}/imgv.py"
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}

}
