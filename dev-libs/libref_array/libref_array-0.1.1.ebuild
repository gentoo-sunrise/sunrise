# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Dynamic array with reference count library"
HOMEPAGE="http://fedorahosted.org/sssd/wiki/"
SRC_URI="http://fedorahosted.org/released/ding-libs/${P}.tar.gz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs trace"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_configure() {
	econf \
		$(use_enable trace trace 7) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	if use doc; then
		emake docs || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	if use doc; then
		dohtml -r doc/html/ || die
	fi
}
