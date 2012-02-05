# Copyright 1999-2012 Gentoo Foundation
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

LANGS="af ar bg bn bs ca cs cy da de el en_GB en_US es et fi fr gl
	gu he hi hr hu id it ja ka km ko lo lt mk mr nb nl pa pl pt pt_BR ro ru si
	sk sl sr sv ta th tr uk vi wa xh zh_CN zh_TW zu"

for X in ${LANGS} ; do
	IUSE+=" linguas_${X}"
done
unset X

DEPEND="dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-tex/latex2html )"
RDEPEND=""

S=${WORKDIR}/apparmor-${PV}/parser

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	local lang
	for lang in ${LANGS}; do
		if ! use linguas_${lang}; then
			rm po/${lang}.po || die "failed to remove nls"
		fi
	done
}

src_compile()  {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" arch manpages
	use doc && emake pdf
}

src_install() {
	emake DESTDIR="${D}" arch manpages install

	dodir /etc/apparmor.d

	newinitd "${FILESDIR}"/${PN}-init ${PN}
	newconfd "${FILESDIR}"/${PN}-confd ${PN}

	dodoc README
	use doc && dodoc techdoc.pdf
}
