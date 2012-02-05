# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils perl-module versionator

DESCRIPTION="Additional userspace utils to assist with AppArmor profile management"
HOMEPAGE="http://apparmor.net/"
SRC_URI="http://launchpad.net/apparmor/$(get_version_component_range 1-2)/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

LANGS="af ar bg bn bs ca cs cy da de el en_GB en_US es et fi fr gl
	gu he hi hr hu id it ja ka km ko lo lt mk mr nb nl pa pl pt
	pt_BR pt_PT ro ru si sk sl sr sv ta th tr uk vi wa xh zh_CN
	zh_TW zu"

for X in ${LANGS} ; do
	IUSE+=" linguas_${X}"
done
unset X

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	~sys-libs/libapparmor-${PV}[perl]
	~sys-apps/apparmor-${PV}
	dev-perl/Locale-gettext
	dev-perl/RPC-XML
	dev-perl/TermReadKey
	virtual/perl-Data-Dumper
	virtual/perl-Getopt-Long"

S=${WORKDIR}/apparmor-${PV}/utils

src_prepare() {
	local lang
	for lang in ${LANGS}; do
		if ! use linguas_${lang}; then
			rm po/${lang}.po || die "failed to remove nls"
		fi
	done
}

src_install() {
	perlinfo
	emake DESTDIR="${D}" PERLDIR="${D}/${VENDOR_LIB}/Immunix" install
}
