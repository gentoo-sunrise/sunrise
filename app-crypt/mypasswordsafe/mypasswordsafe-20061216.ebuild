# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils qt3 toolchain-funcs

MY_P=${P/mypasswords/MyPasswordS}

DESCRIPTION="A password manager compatible with Password Safe."
HOMEPAGE="http://www.semanticgap.com/myps/"
SRC_URI="http://www.semanticgap.com/myps/release/${MY_P}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/qt-3.3:3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PF}-qtdir.patch"
}

src_compile() {
	emake CXX=$(tc-getCXX) PREFIX="/usr" all || die "emake failed"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "emake install failed"
}
