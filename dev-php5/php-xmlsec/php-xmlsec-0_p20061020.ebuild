# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PHP_EXT_NAME="xmlsec"
PHP_EXT_ZENDEXT="no"
PHP_EXT_INI="yes"

inherit php-ext-source-r1

MY_PN="xmlsec"

DESCRIPTION="A native PHP-extension to the XML Signature and Encryption library"
HOMEPAGE="http://edocs.phpclub.net/xmlsec/"
SRC_URI="http://edocs.phpclub.net/${MY_PN}/${MY_PN}.zip -> ${P}.zip"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/xmlsec[ssl]
	dev-libs/libgcrypt"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

need_php_by_category
