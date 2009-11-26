# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="A library that abstracts the control group file system in Linux"
HOMEPAGE="http://libcg.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcg/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="daemon debug pam tools"

DEPEND="dev-util/yacc
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable tools) \
		$(use_enable pam) \
		$(use_enable daemon)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
}
