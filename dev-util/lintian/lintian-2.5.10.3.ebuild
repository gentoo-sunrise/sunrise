# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

#revision for stable versions (e.g. +squeeze1)
MY_PVR=""

inherit eutils

DESCRIPTION="Debian package checker"
HOMEPAGE="http://packages.qa.debian.org/${PN}"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}${MY_PVR}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8.8-r8"
RDEPEND="app-arch/dpkg
	app-misc/hardening-wrapper
	dev-perl/Archive-Zip
	dev-perl/Class-Accessor
	dev-perl/Clone
	dev-perl/IPC-Run
	dev-perl/Parse-DebianChangelog
	dev-perl/Apt-Pkg
	dev-perl/TimeDate
	dev-perl/URI
	dev-util/diffstat
	dev-util/intltool-debian
	sys-apps/man-db
	sys-devel/gettext
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Fixes incorrect reading of exit code for dpkg-vendor
	epatch "${FILESDIR}"/${P}-FrontendUtil.pm.patch
	# generate man pages
	mkdir man/man1 || die
	private/generate-lintian-pod | pod2man --name lintian \
		--center "Debian Package Checker" --section=1 > man/man1/lintian.1 || die
	pod2man --section=1 man/lintian-info.pod > man/man1/lintian-info.1 || die
}

src_install() {
	insinto /etc
	newins doc/${PN}rc.example ${PN}rc
	dobin frontend/{${PN},${PN}-info}

	local mysharedir=/usr/share/${PN}
	insinto ${mysharedir}
	doins -r checks lib profiles vendors
	doins -r vendors/debian/ftp-master-auto-reject/data

	insinto ${mysharedir}/collection
	doins collection/*.desc
	rm collection/*.desc || die

	exeinto ${mysharedir}/collection
	doexe collection/*

	dodoc doc/{CREDITS,desc-files,${PN}.xml,README.developers}
	dodoc debian/changelog
	newdoc doc/README.in README
	doman man/man1/*

	keepdir /var/lib/${PN}
	keepdir /var/spool/${PN}
}
