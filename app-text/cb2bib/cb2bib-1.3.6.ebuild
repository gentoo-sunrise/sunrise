# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="http://www.molspaces.com/cb2bib/"
SRC_URI="http://www.molspaces.com/dl/progs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="debug +lzo +poll"

DEPEND=">=x11-libs/qt-webkit-4.5.3:4[debug?]
	x11-libs/libX11
	x11-proto/xproto
	lzo? ( dev-libs/lzo )"
RDEPEND="${DEPEND}"

src_prepare() {
	# we need to make these two scripts executable before running qmake
	# then qmake picks that up and installs them with $(INSTALL_PROGRAM), 
	# i.e. executable. :]
	#
	chmod +x c2bscripts/c2bimport || die
	chmod +x c2bscripts/c2bciter || die
}

src_configure() {
	# We need to unset QTDIR here, else we may end up with qt3 if it is installed.
	QTDIR="" ./configure \
		$(use_enable lzo) \
		$(use_enable poll cbpoll) \
		--qmakepath /usr/bin/qmake \
		--prefix /usr \
		--bindir /usr/bin \
		--datadir /usr/share \
		--desktopdatadir /usr/share/applications \
		--icondir /usr/share/pixmaps \
		--disable-qmake-call || die "cb2bib provided configure failed"

	# configure writes the additional qmake commandline parameters into a 
	# file "qmake-additional-args"
	eqmake4 ${PN}.pro $(cat qmake-additional-args)
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}

pkg_postinst() {
	elog "For best functionality, emerge the following packages:"
	elog "    app-text/poppler-utils       - for data import from PDF files"
	elog "    app-text/bibutils            - for data import from ISI, endnote format"
	elog "    media-fonts/jsmath           - for displaying mathematical notation"
	elog "    >=media-libs/exiftool-7.3.1  - for, err, some additional features :)"
	elog "    app-text/dvipdfm             - for data import from DVI files"
	elog "    virtual/latex-base           - to check for BibTeX file correctness and to get"
	elog "                                   nice printing through the shell script bib2pdf"
}
