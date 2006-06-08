# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils pam

DESCRIPTION="pam interface to existing S/Key library/interface"
HOMEPAGE="http://freshmeat.net/projects/pam_skey/"
SRC_URI="http://kreator.esa.fer.hr/projects/tarballs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=sys-libs/pam-0.78-r3
	>=app-admin/skey-1.1.5-r4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch || die "patch failed"
}

src_compile() {
	econf --libdir="/$(get_libdir)" || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README INSTALL
	newpamd ${FILESDIR}/pam_skey-system-auth.pam.d system-auth
}
