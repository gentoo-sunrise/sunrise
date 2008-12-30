# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Library to read the content of dBASE III, IV, and 5.0 files"
HOMEPAGE="http://developer.berlios.de/projects/dbf/"
SRC_URI="mirror://berlios/dbf/${P}.src.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-perl/XML-Parser
	doc? ( app-text/docbook-sgml-utils )
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

src_compile() {
	chmod u+x configure
	if use doc; then
		export DOC_TO_MAN=docbook2man
	fi
	econf
	emake || die "emake failed"
}

src_install() {
	chmod u+x install-sh
	emake DESTDIR="${D}" install || die "make install failed"
}
