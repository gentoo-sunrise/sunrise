# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="A framework and services to support system-level performance monitoring and performance management"
HOMEPAGE="http://oss.sgi.com/projects/pcp/"
SRC_URI="ftp://oss.sgi.com/projects/pcp/download/${P}-2.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""
RDEPEND=""

src_compile() {
	filter-flags -fomit-frame-pointer
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	DIST_ROOT="${D}" emake install || die "emake install failed"
	dodoc CHANGELOG README
}
