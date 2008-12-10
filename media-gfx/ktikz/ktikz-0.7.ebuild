# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4

DESCRIPTION="A QT4-based editor for the TikZ language."
HOMEPAGE="http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language"
SRC_URI="http://www.hackenberger.at/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-core
	x11-libs/qt-gui
	app-text/poppler-bindings[qt4]
	virtual/latex-base
	dev-texlive/texlive-latexextra
	dev-tex/pgf"
RDEPEND="${DEPEND}"

src_prepare() {
	# don't install desktop icon (and cause sandbox violation)
	sed -i -e '59,66d' src/src.pro || die "sed failed"
	# ... and libs are not equal ldflags, make that sure:
	sed -i -e 's|QMAKE_LFLAGS|LIBS|' macros.pri || die "sed failed"
}

src_configure() {
	eqmake4 ${PN}.pro PREFIX="${D}/usr" "CONFIG+=nostrip" || die "eqmake4 failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc Changelog TODO

	newicon src/images/${PN}-128.png ${PN}.png
	make_desktop_entry ${PN} KtikZ ${PN} Graphics
}
