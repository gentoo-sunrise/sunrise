# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PHP_EXT_NAME="expect"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php5-3"

inherit php-ext-pecl-r2

DESCRIPTION="PHP extension for expect library."
HOMEPAGE="http://pecl.php.net/package/expect/"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-tcltk/expect"
RDEPEND="${DEPEND}"
