# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit versionator sgml-catalog

MY_PV=$(replace_version_separator 2 '+')
MY_PV=${MY_PV/p/nmu}

DESCRIPTION="XML infrastructure and XML catalog file support"
HOMEPAGE="http://packages.debian.org/xml-core"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-lang/perl"
RDEPEND="app-text/sgml-base
	dev-util/debhelper
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/dtd/xml-core/catalog"

src_compile() {
	emake prefix="${D}"/usr
}

src_install() {
	emake prefix="${D}"/usr install
	insinto /usr/share/sgml/dtd/${PN}
	doins schemas/{catalog,catalog.dtd}
	insinto /usr/share/xml/schema/${PN}
	doins schemas/catalog.xml
	keepdir /var/lib/${PN}
	insinto /usr/share/lintian/overrides
	doins debian/lintian-overrides/xml-core
	dodoc debian/{README.Debian,TODO,changelog}
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
