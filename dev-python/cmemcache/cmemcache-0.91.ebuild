# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python extension for libmemcache (similar to python-memcache)"
HOMEPAGE="http://gijsbert.org/cmemcache/"
SRC_URI="http://gijsbert.org/downloads/cmemcache/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/libmemcache-1.4.0_rc2"
