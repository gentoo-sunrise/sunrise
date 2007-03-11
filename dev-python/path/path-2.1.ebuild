# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python multilib

DESCRIPTION="Helpful python wrapper to the os.path module"
HOMEPAGE="http://www.jorendorff.com/articles/python/path"
SRC_URI="http://www.jorendorff.com/articles/python/path/${P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	python_version
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/
	doins path.py
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages
}

pkg_postrm() {
	python_version
	python_mod_cleanup ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages
}
