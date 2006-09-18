# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GenealogyJ is a viewer and editor for genealogic data and is written in Java"
HOMEPAGE="http://genj.sf.net/"
SRC_URI="mirror://sourceforge/genj/genj_app-${PV}.zip
	skins? ( mirror://sourceforge/genj/genj_lnf-2.0.zip )
	geoview? ( mirror://sourceforge/genj/genj_geo-${PV}.zip )"

S=${WORKDIR}
PROGRAM_DIR=/opt/${PN}
LANGS="de en es fr hu nl pl pt_BR"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="geoview skins"
for X in ${LANGS} ; do
    SRC_URI="${SRC_URI} linguas_${X}? ( mirror://sourceforge/genj/genj_${X}-${PV}.zip )"
    IUSE="${IUSE} linguas_${X}"
done

if [ -z "${LINGUAS}" ]; then
    SRC_URI="${SRC_URI} linguas_en? ( mirror://sourceforge/genj/genj_en-${PV}.zip )"
    IUSE="${IUSE} linguas_en"
fi


DEPEND=">=virtual/jre-1.4
    app-arch/unzip"
RDEPEND="${DEPEND}"

pkg_setup() {
	if [ -z "${LINGUAS}" ]; then
		ewarn " To install a localized version, set the according LINGUAS variable(s). Default: en "
		ewarn " Supported localizations: de en es fr hu* nl* pt_BR* pl*"
		ewarn " (* = Help file in English only. Upstream doesn't have a translation.) "
	fi
}

src_compile() {
	einfo "Binary only installation, no compilation needed."
}

src_install() {
	insinto ${PROGRAM_DIR}
	exeinto ${PROGRAM_DIR}

	doins *.jar
	doins run.sh
	# Necessary to be able to run it as a user:
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
	use skins && cp -R lnf/ ${D}/${PROGRAM_DIR}/

	cp -R report/ ${D}/${PROGRAM_DIR}/
	cp -R help/ ${D}/${PROGRAM_DIR}/
	cp -R contrib/ ${D}/${PROGRAM_DIR}/
}
pkg_postinst() {
	einfo
	einfo "This ebuild does not install the GenealogyJ web applet"
	einfo
}