# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Open Source Security Assertion Markup Language implementation"
HOMEPAGE="http://www.opensaml.org/"
SRC_URI="http://shibboleth.internet2.edu/downloads/${PN}/cpp/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/openssl
	net-misc/curl
	dev-libs/log4shib
	dev-libs/xerces-c
	>=dev-libs/xml-security-c-1.3.0"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# make documentation location Gentoo like    
	epatch "${FILESDIR}"/opensaml_doc.diff
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc doc/NEWS.txt doc/NOTICE.txt doc/README.txt
}
