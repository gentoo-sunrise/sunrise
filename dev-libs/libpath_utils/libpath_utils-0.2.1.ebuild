# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="File path names manipulation library"
HOMEPAGE="http://fedorahosted.org/sssd/"
SRC_URI="http://fedorahosted.org/released/ding-libs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc static-libs test"

DEPEND="doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"
RDEPEND=""

src_configure() {
	econf $(use_enable static-libs static)
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
