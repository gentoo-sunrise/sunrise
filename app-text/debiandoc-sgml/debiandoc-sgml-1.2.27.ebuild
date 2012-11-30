# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit perl-module sgml-catalog

DESCRIPTION="DebianDoc SGML DTD and formatting tools"
HOMEPAGE="http://packages.qa.debian.org/debiandoc-sgml"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk"

RDEPEND="app-text/openjade
	dev-lang/perl
	dev-libs/xml-core
	dev-perl/HTML-Parser
	dev-perl/Roman
	dev-perl/SGMLSpm
	dev-perl/Text-Format
	dev-perl/URI
	virtual/perl-i18n-langtags
	cjk? ( dev-tex/cjk-latex )"

sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/debiandoc/dtd/sgml/1.0/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/debiandoc/entities/catalog"

pkg_pretend() {
	if [[ "${LINGUAS}" == *"zh_TW"* ]] && ! use cjk; then
		ewarn "To have proper support for zh_TW in LINGUAS,"
		ewarn "You should enable the cjk USE flag for this package."
	fi
}

src_prepare() {
	perl-module_src_prep
	sed -e "s#\$(pkg_format_dir) \$(pkg_bin_dir)#${VENDOR_LIB}/DebianDoc_SGML/Format /usr/share/\$(pkg_name)#" \
		-i Makefile || die
}

src_compile() {
	emake prefix="${D}"/usr perl_dir="${D}${VENDOR_LIB}"
}

src_install() {
	emake prefix="${D}"/usr perl_dir="${D}${VENDOR_LIB}" install
}
