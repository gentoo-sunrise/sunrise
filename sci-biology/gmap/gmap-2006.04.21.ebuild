# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Genomic Mapping and Alignment Program for mRNA and EST Sequences"
LICENSE="gmap"
HOMEPAGE="http://www.gene.com/share/gmap/"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

RESTRICT="nomirror"

inherit versionator

MY_P=$(replace_all_version_separators '-' ${PV})
SRC_URI="http://www.gene.com/share/gmap/src/gmap-${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

src_install() {
	emake install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog README
}
