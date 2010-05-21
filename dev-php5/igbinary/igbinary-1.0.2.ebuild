# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PHP_EXT_NAME="igbinary"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-source-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A fast drop in replacement for the standard PHP serialize"
HOMEPAGE="http://opensource.dynamoid.com/"
SRC_URI="http://opensource.dynamoid.com/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""

need_php_by_category

src_compile() {
	my_conf="--enable-igbinary"
	php-ext-source-r1_src_compile
}

src_install() {
	php-ext-source-r1_src_install
	dodoc-php CREDITS ChangeLog EXPERIMENTAL NEWS README || die
	php-ext-base-r1_addtoinifiles ";igbinary.compact_strings" '"On"'
}
