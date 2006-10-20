# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Libiqxmlrpc is an object-oriented library, which represents simple XML-RPC solution both for client and server sides."
HOMEPAGE="http://libiqxmlrpc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc debug"

RDEPEND="=dev-cpp/libxmlpp-1*
	dev-libs/libxml2
	dev-libs/boost
	dev-libs/openssl"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if ! built_with_use dev-libs/boost threads ; then
		eerror "dev-libs/boost has to be compiled with 'threads' USE-flag enabled."
		die "Needed USE-flag for dev-libs/boost not found."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-doc_manual_install.patch"
}

src_compile() {
	econf \
		$(use_enable doc docs) \
		$(use_enable debug) \
		--with-boost-thread=boost_thread-mt \
		--with-boost--program-options=boost_program_options-mt \
		--with-boost-unit-test-framework=boost_unit_test_framework-mt \
		|| die "econf failed"
	emake CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS TODO
	if use doc; then
		dohtml doc/libiqxmlrpc.html/*
	fi
}

src_test() {
	einfo "This can take some time due to stress tests"
	cd "${S}/tests"
	make check
	./regression.sh
}
