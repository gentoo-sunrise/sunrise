# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PHP_EXT_NAME="bcompiler"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README TODO"

inherit php-ext-pecl-r2

DESCRIPTION="PHP bytecode Compiler."
HOMEPAGE="http://pecl.php.net/package/bcompiler"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	for slot in $(php_get_slots); do
		# this patch is not needed for php-5.3.x
		if [[ ${slot} == "php5.2" ]]; then
			php_init_slot_env ${slot}
			epatch "${FILESDIR}/zend_is_callable.patch"
		fi
	done
	
	php-ext-source-r2_src_prepare
}
