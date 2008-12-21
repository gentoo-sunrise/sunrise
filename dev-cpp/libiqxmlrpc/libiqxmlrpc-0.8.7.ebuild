# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="An object-oriented library which represents simple XML-RPC solution for client and server side."
HOMEPAGE="http://sourceforge.net/projects/libiqxmlrpc"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc debug"

RDEPEND="=dev-cpp/libxmlpp-1*
	dev-libs/libxml2
	>=dev-libs/boost-1.34.1
	dev-libs/openssl"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PV}-boost_test_framework_detection.patch"
	AT_M4DIR="m4"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable doc docs) \
		$(use_enable debug) \
		--with-boost-unit-test-framework \
		|| die "econf failed"
	emake CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	# We install the docs manually, because: i) sandbox violations ii) wrong location
	emake DESTDIR="${D}" MKDOC=no install || die "emake install failed"
	dodoc ChangeLog README NEWS
	if use doc; then
		dohtml doc/libiqxmlrpc.html/*
	fi
}
