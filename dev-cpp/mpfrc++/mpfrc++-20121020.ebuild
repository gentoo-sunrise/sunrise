# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="High-performance C++ interface for MPFR library"
HOMEPAGE="http://www.holoborodko.com/pavel/mpfr/"
SRC_URI="mirror://github/jauhien/sources/${P//+/%2B}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/mpfr
	dev-libs/gmp"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/include
	doins mpreal.h
	dodoc -r example
}
