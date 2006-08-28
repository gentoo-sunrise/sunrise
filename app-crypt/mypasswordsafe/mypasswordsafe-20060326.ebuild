# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt3 toolchain-funcs

MY_PN="MyPasswordSafe"
DESCRIPTION="MyPasswordSafe is a password manager compatible with Password Safe."
HOMEPAGE="http://www.semanticgap.com/myps/"
SRC_URI="http://www.semanticgap.com/myps/release/${MY_PN}-${PV}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="$(qt_min_version 3.3.6)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PF}-gentoo.patch" || die "patch failed"
}

src_compile() {
	emake CXX=$(tc-getCXX) PREFIX="/usr" all || die "failed to compile"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "install failed"
}
