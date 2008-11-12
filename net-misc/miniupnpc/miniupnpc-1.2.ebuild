# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="UPnP client library and a simple UPnP client."
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"
HOMEPAGE="http://miniupnp.free.fr/"

LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

src_install () {
	emake PREFIX="${D}" install || die "install failed"
	dodoc README Changelog.txt || die "install failed"
	doman man3/* || die "install failed"
}
