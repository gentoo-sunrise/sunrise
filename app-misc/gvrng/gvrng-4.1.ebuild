# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="The Guido van Robot Programming Language"
HOMEPAGE="http://gvr.sourceforge.net"
SRC_URI="mirror://sourceforge/gvr/GvRng_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="dev-lang/python
	>=dev-python/pygtk-2.0.0
	dev-python/pygobject
	>=dev-python/pygtksourceview-2.0.0"

RDEPEND="${DEPEND}"

S=${WORKDIR}/GvRng_${PV}

src_unpack() {
	unpack ${A}
	cd "${S}" || die "Failed to change path to sources"
	epatch "${FILESDIR}"/01_gui_gtk_path.patch
}

src_install() {
	insinto /usr/share/${PN}
	doins -r *.py gvrngrc gui-gtk bitmaps gvr_progs locale po || die "Failed to install files"
	dodoc Changelog docs/Summary-en.txt || die "Failed to install docs"
	if use doc; then
		dohtml -r docs/tutorial.html docs/lessons || die "Failed to install tutorial and lessons"
	fi
	fperms 755 /usr/share/${PN}/gvrng.py || die "Failed to set permissions on gvrng.py"
	dodir /usr/bin || die "Failed to create /usr/bin"
	dosym /usr/share/${PN}/gvrng.py /usr/bin/gvrng || die "Failed to create symlink"
	domenu "${FILESDIR}"/gvrng.desktop || die "Failed to copy desktop file"
	doman docs/gvrng.1.gz  || die "Failed to install man page"
}

pkg_postinst() {
	einfo "The tutorial and the lessons can be found in "
	einfo "/usr/share/doc/${PF}."
	einfo "If you can not find them, emerge the package with USE=doc."
}
