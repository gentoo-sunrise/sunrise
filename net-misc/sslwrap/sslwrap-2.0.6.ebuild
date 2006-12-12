# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_P=${PN}$(delete_all_version_separators)
DESCRIPTION="TSL/SSL - Port Wrapper"
HOMEPAGE="http://quiltaholic.com/rickk/sslwrap/"
SRC_URI="http://quiltaholic.com/rickk/sslwrap/${MY_P}.tar.gz
	mirror://gentoo/${PN}-gentoo.tar.bz2"

LICENSE="sslwrap"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/openssl-0.9.6"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack () {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's:-O2:${CFLAGS}:' \
		-e "s:/usr/local/ssl/include:/usr/include/openssl:" \
		Makefile || die "sed failed"

	cp ${WORKDIR}/${PN}-gentoo/*.c "${S}"
	has_version '=dev-libs/openssl-0.9.7*' \
		&& epatch "${FILESDIR}/${PV}-openssl-0.9.7.patch"
	sed -i \
		-e 's:OPENSSL":"openssl/:g' \
		*.h *.c || die "sed failed"
	sed -i \
		-e "s/SSL_OP_NON_EXPORT_FIRST/SSL_OP_CIPHER_SERVER_PREFERENCE/g" \
		s_server.c || die "sed failed"
}

src_install() {
	dosbin sslwrap
	dodoc README
	dohtml -r ./
}
