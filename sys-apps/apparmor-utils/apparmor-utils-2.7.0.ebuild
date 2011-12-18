# Copyright 1999-2011 Gentoo Foundation
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

src_install() {
	perlinfo
	emake DESTDIR="${D}" PERLDIR="${D}/${VENDOR_LIB}/Immunix" install
}
