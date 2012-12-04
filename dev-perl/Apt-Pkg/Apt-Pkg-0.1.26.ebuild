# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit perl-module

MY_PN="libapt-pkg-perl"

DESCRIPTION="Perl interface to libapt-pkg"
HOMEPAGE="http://packages.qa.debian.org/libapt-pkg-perl"
SRC_URI="mirror://debian/pool/main/liba/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="sys-apps/apt[apt-pkg]
	virtual/libstdc++:3.3
	virtual/perl-Scalar-List-Utils"
DEPEND="virtual/perl-ExtUtils-MakeMaker
	${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	# MakeMaker does not respect CC/CXX
	mymake=( CC=$(tc-getCXX) )
	perl-module_src_compile
}

src_install() {
	perl-module_src_install
	# Install coding examples
	dodoc debian/changelog
	if use examples; then
		dodoc -r examples
	fi
}
