# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GenealogyJ is a viewer and editor for genealogic data and is written in Java"
HOMEPAGE="http://genj.sf.net/"
SRC_URI="mirror://sourceforge/genj/genj_app-${PV}.zip"
S=${WORKDIR}
PROGRAM_DIR=/opt/${PN}

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=virtual/jre-1.3
    app-arch/unzip"
RDEPEND="${DEPEND}"

src_compile() {
	einfo "Binary only installation, no compilation needed."
}

src_install() {
	insinto ${PROGRAM_DIR}
	exeinto ${PROGRAM_DIR}

	doins *.jar
	doins run.sh
	fperms 777 ${PROGRAM_DIR}/run.sh

	insinto ${PROGRAM_DIR}/lib/

	doins lib/*

	insinto ${PROGRAM_DIR}/gedcom/
	doins gedcom/*

	insinto ${PROGRAM_DIR}/report/
	doins report/*
	
	insinto ${PROGRAM_DIR}/doc/
	doins doc/*

	dobin ${FILESDIR}/genealogyj
}