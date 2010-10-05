# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Library to read the content of dBASE III, IV, and 5.0 files"
HOMEPAGE="http://developer.berlios.de/projects/dbf/"
SRC_URI="mirror://berlios/dbf/${P}.src.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-perl/XML-Parser
	doc? ( app-text/docbook-sgml-utils )
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	# Avoid collisions with /usr/include/endian.h
	# installed by e.g. sys-libs/glibc-2.12.1-r1
	cd src || die "src dir missing"
	mv endian.h dbf_endian.h || die "endian.h couldn't be renamed"
	sed -i 's/endian\.h/dbf_endian.h/g' Makefile.in *.c *.h \
		|| die "error executing sed"
}

src_configure() {
	chmod u+x configure
	if use doc; then
		export DOC_TO_MAN=docbook2man
	fi
	econf
}

src_install() {
	chmod u+x install-sh
	emake DESTDIR="${D}" install || die "make install failed"
}
