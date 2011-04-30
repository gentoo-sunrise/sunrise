# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Program for printing one or more image files with a user-defined page layout"
HOMEPAGE="http://kornelix.squarespace.com/mashup"
SRC_URI="http://kornelix.squarespace.com/storage/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	# provide real PREFIX here as it is used in zfuncs.cc
	# provide HTML-dir for DOCDIR as it used only to display the userguide
	emake CXX="$(tc-getCXX)" PREFIX=/usr DOCDIR=/usr/share/doc/${PF}/html || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins data/*
	doicon icons/*
	insinto /usr/share/
	doins -r locales/*

	make_desktop_entry ${PN} "Printoxx" /usr/share/${PN}/icons/${PN}.png "Application;Graphics;2DGraphics;"
	newman doc/${PN}.man ${PN}.1 || die

	rm -rf "${D}"/tmp || die
	dodoc doc/{CHANGES,TRANSLATIONS} || die
	dohtml -r doc/*.html doc/images || die
}
