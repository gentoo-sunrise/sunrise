# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python multilib

DESCRIPTION="A utility to find various forms of lint on a filesystem"
HOMEPAGE="http://www.pixelbeat.org/fslint/"
SRC_URI="http://www.pixelbeat.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND=">=dev-python/pygtk-2.0"

src_install() {
	dodir /usr/share/${PN}
	cp -R ${PN}/ "${D}"/usr/share/${PN}

	insinto /usr/share/${PN}
	doins ${PN}{.glade,.gladep,_icon.png} || die "doins failed"

	exeinto /usr/bin
	doexe ${PN}-gui || die "doexe failed"

	python_version
	local pydir="/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
	dodir ${pydir}
	echo "liblocation = '/usr/share/${PN}/'" > "${D}"/${pydir}/__init__.py

	doicon ${PN}_icon.png
	domenu ${PN}.desktop

	dodoc doc/*
	doman man/*

	if use nls ; then
		cd po
		emake DESTDIR="${D}"/usr DATADIR=share install || die "locales install failed"
	fi
}

pkg_postinst() {
	python_mod_optimize "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}

pkg_postrm() {
	python_version
	python_mod_cleanup "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}
