# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

DESCRIPTION="The Guido van Robot Programming Language"
HOMEPAGE="http://gvr.sourceforge.net"
SRC_URI="mirror://sourceforge/gvr/GvRng_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="${PYTHON_DEPS}
	dev-python/pygtk:2
	dev-python/pygobject:2
	dev-python/pygtksourceview:2"

RDEPEND="${DEPEND}"

S="${WORKDIR}/GvRng_${PV}"

src_prepare() {
	epatch "${FILESDIR}"/01_gui_gtk_path.patch
}

src_install() {
	insinto /usr/share/${PN}
	doins -r *.py gvrngrc gui-gtk bitmaps gvr_progs locale po
	dodoc Changelog docs/Summary-en.txt
	if use doc; then
		dohtml -r docs/tutorial.html docs/lessons
	fi
	fperms 755 /usr/share/${PN}/gvrng.py
	dodir /usr/bin
	dosym /usr/share/${PN}/gvrng.py /usr/bin/gvrng
	domenu "${FILESDIR}"/gvrng.desktop
	doman docs/gvrng.1.gz
}

pkg_postinst() {
	einfo "The tutorial and the lessons can be found in "
	einfo "/usr/share/doc/${PF}."
	einfo "If you can not find them, emerge the package with USE=doc."
}
