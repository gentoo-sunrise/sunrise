# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils toolchain-funcs

MY_PV="$(replace_version_separator 2 '-')"
MY_PN=${PN}-III

DESCRIPTION="Better approach to modile Ad-Hoc networking"
HOMEPAGE="http://b.a.t.m.a.n.freifunk.net/"
SRC_URI="http://snr.freifunk.net/svn/b.a.t.m.a.n/${MY_PN}-${MY_PV}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dosbin batman

	newinitd "${FILESDIR}"/batman-init.d batman
	newconfd "${FILESDIR}"/batman-conf.d batman

	dodoc CHANGELOG README THANKS
}
