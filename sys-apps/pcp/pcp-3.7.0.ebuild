# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit flag-o-matic

DESCRIPTION="A framework and services to support system-level performance monitoring and performance management"
HOMEPAGE="http://oss.sgi.com/projects/pcp/"
SRC_URI="ftp://oss.sgi.com/projects/${PN}/download/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND=""

src_configure() {
	filter-flags -fomit-frame-pointer
	econf || die "econf failed"
}
src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	DIST_ROOT="${D}" emake install || die "emake install failed"
	dodoc CHANGELOG README
}
