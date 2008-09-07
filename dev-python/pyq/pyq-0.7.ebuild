# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils multilib

DESCRIPTION="fast, efficient, command-line utility for downloading quotes from Yahoo."
HOMEPAGE="http://rimonbarr.com/repository/pyq/index.html"
SRC_URI="http://rimonbarr.com/repository/${PN}/code/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_unpack() {
	cp "${DISTDIR}"/pyq "${WORKDIR}"
}

src_install() {
	python_version
	cd "${WORKDIR}"
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/
	newins pyq pyq.py
	make_wrapper pyq "python /usr/$(get_libdir)/python${PYVER}/site-packages/pyq.py"
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages"
}

pkg_postrm() {
	python_version
	python_mod_cleanup "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages"
}
