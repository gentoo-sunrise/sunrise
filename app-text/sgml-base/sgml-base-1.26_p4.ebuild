# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit versionator

MY_PV=$(replace_version_separator 2 '+')
MY_PV=${MY_PV/p/nmu}

DESCRIPTION="SGML infrastructure and SGML catalog file support"
HOMEPAGE="http://packages.qa.debian.org/sgml-base"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	emake prefix="${D}"/usr install
	dodoc README debian/{changelog,TODO}
	newdoc debian/sgml-base.NEWS NEWS
}
