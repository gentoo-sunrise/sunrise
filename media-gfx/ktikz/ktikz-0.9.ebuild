# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4

DESCRIPTION="A QT4-based editor for the TikZ language"
HOMEPAGE="http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language"
SRC_URI="http://www.hackenberger.at/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug kde"

DEPEND="x11-libs/qt-gui:4
	|| ( app-text/poppler-bindings[qt4] dev-libs/poppler-qt4 )
	virtual/latex-base
	dev-texlive/texlive-latexextra
	dev-tex/pgf"
RDEPEND="${DEPEND}"

src_prepare() {
	# don't install desktop icon (and cause sandbox violation)
	sed -i -e '72,79d' src/src.pro || die "sed failed"
	# ... and libs are not equal ldflags, make that sure:
	sed -i -e 's|QMAKE_LFLAGS|LIBS|' macros.pri || die "sed failed"

	epatch "${FILESDIR}/${P}-kde-includes.patch"
}

src_configure() {
	if use kde ; then
		KDECONFIG="CONFIG+=usekde"
	else
		KDECONFIG="CONFIG-=usekde"
	fi
	eqmake4 ${PN}.pro PREFIX="${D}/usr" "CONFIG+=nostrip" "$KDECONFIG"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	dodoc Changelog TODO || die "Cannot install documentation"

	newicon src/images/${PN}-128.png ${PN}.png || die "Cannot install icon"
	make_desktop_entry ${PN} KtikZ ${PN} Graphics \
		|| die "Cannot create desktop entry"
}
