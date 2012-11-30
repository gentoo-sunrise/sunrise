# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit sgml-catalog

DESCRIPTION="Common SGML and XML data"
HOMEPAGE="http://packages.qa.debian.org/sgml-data"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-lang/perl
	dev-libs/libxml2
	virtual/perl-Getopt-Long"

sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/dtd/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/entities/ArborText/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/entities/Hewlett-Packard/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/entities/sgml-iso-entities-8879.1986/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/entities/sgml-iso-entities-9573-13.1991/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/html/dtd/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/html/dtd/4.0/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/html/dtd/4.01/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/html/dtd/iso-15445/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/html/entities/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/xml/qaml/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/xml/svg/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/xml/entities/xml-iso-entities-8879.1986/catalog"

src_install() {
	dodir /etc/sgml /etc/xml
	insinto /usr/share/xml
	doins -r xml/*
	dosym /usr/share/xml/declaration/xml.dcl /usr/share/xml/declaration/xml.decl
	insinto /usr/share/sgml
	doins -r sgml/*
	doins -r xml/{declaration,entities}
	dosym /usr/share/xml/declaration/xml.dcl  /usr/share/sgml/declaration/xml.decl
	insinto /usr/share/sgml/dtd
	doins xml/qaml/qaml-xml.dtd xml/svg/svg*
	exeinto /usr/share/${PN}
	doexe sgml-catalog-check.pl
	insinto /usr/share/lintian/overrides
	newins debian/sgml-data.lintian-overrides sgml-data
	dodoc debian/{README.Debian,TODO.Debian,changelog}
	if use examples; then
		insinto /usr/share/doc/${P}
		doins -r examples
	fi

}

pkg_postinst() {
	einfo "Creating package XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --create /etc/xml/${PN}
	einfo "Adding entries to root XML catalog and package XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"+//IDN faq.org//DTD Frequently Asked Questions" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"+//IDN faq.org//DTD Frequently Asked Questions" \
		"${EPREFIX}"/usr/share/xml/qaml/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://xml.ascc.net/xml/resource/qaml-xml" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://xml.ascc.net/xml/resource/qaml-xml" \
		"${EPREFIX}"/usr/share/xml/qaml/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"+//ISBN 82-7640-023//DTD Frequently Asked Questions//EN" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"+//ISBN 82-7640-023//DTD Frequently Asked Questions//EN" \
		"${EPREFIX}"/usr/share/xml/qaml/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"/usr/share/sgml/dtd/qaml-xml.dtd" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"/usr/share/sgml/dtd/qaml-xml.dtd" \
		"${EPREFIX}"/usr/share/xml/qaml/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"-//W3C//DTD SVG" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"-//W3C//DTD SVG" \
		"${EPREFIX}"/usr/share/xml/svg/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://www.w3.org/TR/2001/REC-SVG-20010904/" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://www.w3.org/TR/2001/REC-SVG-20010904/" \
		"${EPREFIX}"/usr/share/xml/svg/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://www.w3.org/Graphics/SVG/1.1/" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://www.w3.org/Graphics/SVG/1.1/" \
		"${EPREFIX}"/usr/share/xml/svg/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"/usr/share/sgml/dtd/svg" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"/usr/share/sgml/dtd/svg" \
		"${EPREFIX}"/usr/share/xml/svg/catalog.xml /etc/xml/${PN}

	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"ISO 8879:1986//ENTITIES" \
		"${EPREFIX}"/etc/xml/${PN} /etc/xml/catalog
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "public" \
		"ISO 8879:1986//ENTITIES" \
		"${EPREFIX}"/usr/share/xml/entities/xml-iso-entities-8879.1986/catalog.xml /etc/xml/${PN}
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
