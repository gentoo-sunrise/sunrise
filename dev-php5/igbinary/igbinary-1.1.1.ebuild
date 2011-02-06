# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PHP_EXT_NAME="igbinary"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php5-2 php5-3"

inherit php-ext-source-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A fast drop in replacement for the standard PHP serialize"
HOMEPAGE="http://opensource.dynamoid.com/"
SRC_URI="http://opensource.dynamoid.com/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	my_conf="--enable-igbinary"
	php-ext-source-r2_src_configure
}
