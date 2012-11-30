# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit versionator sgml-catalog

MY_PV=$(replace_version_separator 2 '+')
MY_PV=${MY_PV/p/nmu}

DESCRIPTION="XML catalog infrastructure support"
HOMEPAGE="http://packages.debian.org/xml-core"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	dev-libs/sgml-data"

S="${WORKDIR}/${PN}-${MY_PV}"

sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/dtd/xml-core/catalog"

src_install() {
	# Note: we don't install update-xmlcatalog or its debhelper
	# because it conflicts with xmlcatalog in libxml2 and xmlcatalog
	# already provides the necessary functionality
	dodir /etc/sgml /etc/xml
	insinto /usr/share/sgml/dtd/${PN}
	doins schemas/{catalog,catalog.dtd}
	insinto /usr/share/xml/schema/${PN}
	doins schemas/catalog.xml
	insinto /usr/share/lintian/overrides
	doins debian/lintian-overrides/xml-core
	dodoc debian/{TODO,changelog}
}

pkg_postinst() {
	einfo "Creating package XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --create /etc/xml/${PN}
	einfo "Adding entries to root XML catalog and package XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd" \
		"${EPREFIX}"/usr/share/xml/schema/xml-core/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"-//OASIS//DTD XML Catalogs V1.0//EN" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"-//OASIS//DTD XML Catalogs V1.0//EN" \
		"${EPREFIX}"/usr/share/xml/schema/xml-core/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://globaltranscorp.org/oasis/catalog/xml/tr9401.dtd" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://globaltranscorp.org/oasis/catalog/xml/tr9401.dtd" \
		"${EPREFIX}"/usr/share/xml/schema/xml-core/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"-//GlobalTransCorp//DTD XML Catalogs V1.0-Based Extension V1.0//EN" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"-//GlobalTransCorp//DTD XML Catalogs V1.0-Based Extension V1.0//EN" \
		"${EPREFIX}"/usr/share/xml/schema/xml-core/catalog.xml /etc/xml/${PN}
	sgml-catalog_pkg_postinst
}

pkg_postrm() {
	einfo "Removing entries from the root XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --del \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	einfo "Removing the package XML catalog"
	if [ -e /etc/xml/${PN} ]; then
		rm /etc/xml/${PN}
	fi
	sgml-catalog_pkg_postrm
}
