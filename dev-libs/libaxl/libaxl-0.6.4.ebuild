# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

REVNUM="b4604.g4608"
MY_P="${PN/lib}-${PV}.${REVNUM}"

DESCRIPTION="Another XML library"
HOMEPAGE="http://www.aspl.es/axl/"
SRC_URI="mirror://sourceforge/vortexlibrary/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc tests"

DEPEND="sys-devel/libtool
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-werror.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc axl-doc) \
		$(use_enable tests axl-test)
}
