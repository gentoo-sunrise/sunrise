# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Measures bandwidth and bytes through a command line pipe"
HOMEPAGE="http://zakalwe.fi/~shd/foss/pmr/"
SRC_URI="http://zakalwe.fi/~shd/foss/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	dobin pmr || die "Failed to install binary"
	doman doc/pmr.1 || die "Failed to install manpage"
}
