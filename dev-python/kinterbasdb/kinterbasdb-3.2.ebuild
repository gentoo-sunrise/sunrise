# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

KEYWORDS="~x86"

DESCRIPTION="Python Database API 2.0-compliant support for the open source relational database Firebird."
HOMEPAGE="http://kinterbasdb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=dev-db/firebird-1.0"
RDEPEND="${DEPEND}
		>=dev-python/egenix-mx-base-2.0.1"

src_install() {
	distutils_src_install
	dodoc docs/changelog.txt
	dohtml docs/*
}
