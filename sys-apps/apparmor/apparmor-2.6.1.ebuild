# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs versionator

DESCRIPTION="Userspace utils and init scripts for the AppArmor application security system"
HOMEPAGE="http://apparmor.net/"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-tex/latex2html )"
RDEPEND=""

RESTRICT="test"

S=${WORKDIR}/apparmor-${PV}/parser

src_prepare() {
	epatch "${FILESDIR}"/apparmor-2.6.1-makefile.patch
}

src_compile()  {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" main manpages
	use doc && emake pdf
}

src_install() {
	emake DISTRO=unknown DESTDIR="${D}" main manpages install

	dodir /etc/apparmor.d

	newinitd "${FILESDIR}"/${PN}-init ${PN}
	newconfd "${FILESDIR}"/${PN}-confd ${PN}

	dodoc README
	use doc && dodoc techdoc.pdf
}
