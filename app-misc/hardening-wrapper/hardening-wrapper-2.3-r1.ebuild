# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Compiler wrapper to enable security hardening flags"
HOMEPAGE="http://packages.qa.debian.org/hardening-wrapper"
SRC_URI="mirror://debian/pool/main/h/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/dpkg
	dev-lang/perl"
RDEPEND="virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-PodParser
	virtual/perl-Term-ANSIColor
	${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin build-tree/{hardened-c++,hardened-cc,hardened-ld,hardening-check}
	insinto /usr/share/lintian/overrides
	newins debian/hardening-wrapper.lintian-overrides hardening-wrapper
	insinto /usr/share/hardening-includes
	doins build-tree/hardening.make
	doman build-tree/*.1
	dodoc TODO AUTHORS debian/{README.Debian,changelog}
}

pkg_postinst() {
	einfo "Symlinks overriding g++, gcc, ld.bfd and ld.gold documented in"
	einfo "debian/hardening-wrapper.links were not installed since they would"
	einfo "conflict with gcc-config settings."
}
