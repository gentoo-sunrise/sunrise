# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A powerful C++ class library for working with MIME messages and services like IMAP, POP or SMTP."
HOMEPAGE="http://www.vmime.org/"
SRC_URI="mirror://sourceforge/vmime/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples sasl ssl"

RDEPEND="sasl? ( net-libs/libgsasl )
		ssl? ( net-libs/gnutls )
		virtual/libiconv"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s|doc/\${PACKAGE_TARNAME}|doc/${PF}|" \
		-e "s|doc/\$(GENERIC_LIBRARY_NAME)|doc/${PF}|" \
		configure Makefile.in || die "sed failed"
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable sasl) \
		$(use_enable ssl tls) \
		--enable-platform-posix \
		--enable-messaging \
		--enable-messaging-proto-pop3 \
		--enable-messaging-proto-smtp \
		--enable-messaging-proto-imap \
		--enable-messaging-proto-maildir \
		--enable-messaging-proto-sendmail \
		|| die "econf failed"
	emake || die "emake failed"
	if use doc ; then
		doxygen vmime.doxygen || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use doc ; then
		dohtml doc/html/*
	fi

	insinto /usr/share/doc/${PF}
	use examples && doins -r examples
}
