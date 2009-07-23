# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="An object-oriented library which represents simple XML-RPC solution for client and server side."
HOMEPAGE="http://libiqxmlrpc.wikidot.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc debug"

RDEPEND="=dev-cpp/libxmlpp-1*
	dev-libs/libxml2
	>=dev-libs/boost-1.35.0-r5
	dev-libs/openssl"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}/${PV}-boost_test_framework_detection.patch"
	AT_M4DIR="m4"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc docs) \
		$(use_enable debug) \
		--with-boost-unit-test-framework
}

src_compile() {
	# otherwise the package ignores them
	emake CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	# We install the docs manually, because: i) sandbox violations ii) wrong location
	emake DESTDIR="${D}" MKDOC=no install || die "emake install failed"
	dodoc ChangeLog README NEWS
	use doc && dohtml doc/libiqxmlrpc.html/*
}
