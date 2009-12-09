# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="http://www.molspaces.com/cb2bib/"
SRC_URI="http://www.molspaces.com/dl/progs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="debug +lzo +poll"

DEPEND=">=x11-libs/qt-webkit-4.4:4
	x11-libs/libX11
	x11-proto/xproto
	lzo? ( dev-libs/lzo )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}"-{disable-cbpoll,noqmake}.patch )

src_configure() {
	# The non-standard configure script has only few options, not a matching 
	# --enable for every --disable, and uses _ instead of - as separator...
	# So do things manually...
	# We need to unset QTDIR here, else we may end up with qt3 if it is installed.
	QTDIR="" ./configure \
		$(use lzo  || echo --disable_lzo) \
		$(use poll || echo --disable_cbpoll) \
		--qmakepath /usr/bin/qmake \
		--prefix /usr \
		--bindir /usr/bin \
		--datadir /usr/share \
		--desktopdatadir /usr/share/applications \
		--icondir /usr/share/pixmaps || die "cb2bib provided configure failed"

	# configure is patched not to run qmake itself but just write the commandline 
	# parameters into a file "qmake-additional-args"
	eqmake4 ${PN}.pro $(cat qmake-additional-args)
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	# qmake or src.pro defect: scripts are installed by $(INSTALL_FILE)
	# instead of $(INSTALL_PROGRAM), and thus the executable bit becomes
	# cleared
	fperms +x "/usr/bin/c2bimport" || die
	fperms +x "/usr/bin/c2bciter"  || die
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
