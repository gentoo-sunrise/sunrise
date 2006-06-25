# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Libiqxmlrpc is an object-oriented library, which represents simple XML-RPC solution both for client and server sides."
HOMEPAGE="http://libiqxmlrpc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc debug"

RDEPEND="=dev-cpp/libxmlpp-1*
	dev-libs/boost
	dev-libs/openssl"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	if built_with_use -o dev-libs/boost threads threads_only; then
		cd "${S}"
		sed -i -e 's/boost_thread/boost_thread-mt/g' \
			libiqxmlrpc/Makefile.in \
			libiqxmlrpc.pc.in \
			tests/Makefile.in || die "fixing link to boost failed"
	fi
	epatch "${FILESDIR}/${PV}-value_type-namespace_and_template.patch"
	epatch "${FILESDIR}/${PV}-doc_manual_install.patch"
}

src_compile() {
	econf \
		$(use_enable doc docs) \
		$(use_enable debug) || die "econf failed"
	emake || die "emake failed"
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
