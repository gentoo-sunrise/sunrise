# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="Epinions implementation of xmlrpc protocol in C."
HOMEPAGE="http://xmlrpc-epi.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlrpc-epi/${P}.tar.gz"

LICENSE="xmlrpc-epi"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-libs/expat"
DEPEND="$RDEPEND"

src_install() {
	einstall || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README
}
