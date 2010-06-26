# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base

DESCRIPTION="Filter files out of unified diffs using POSIX extended regular expressions"
HOMEPAGE="http://ohnopub.net/~ohnobinki/difffilter/"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=dev-libs/liblist-2.3.1
	dev-libs/tre"
DEPEND="doc? ( app-text/txt2man )
	${RDEPEND}"

src_configure() {
	econf $(use_enable doc)
}
