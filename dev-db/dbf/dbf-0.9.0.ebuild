# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN}-core"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Command line tool to convert dBASE (III, IV, 5.0) files to CSV or SQL"
HOMEPAGE="http://developer.berlios.de/projects/dbf/"
SRC_URI="mirror://berlios/dbf/${MY_P}.src.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="dev-libs/libdbf"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-perl/XML-Parser
	doc? ( app-text/docbook-sgml-utils )
	dev-util/pkgconfig"


S=${WORKDIR}/${MY_PN}

src_compile() {
	sed -i 's/docbook-to-man/$(DOC_TO_MAN)/' man/Makefile*
	chmod u+x configure
	if use doc; then
		export DOC_TO_MAN=docbook2man
	fi
	econf
	emake || die "emake failed"
	if use doc; then
		mv man/DBF.SECTION man/dbf.1 || die "Error moving man page"
	fi
}

src_install() {
	chmod u+x install-sh
	emake DESTDIR="${D}" install || die "make install failed"
}
