# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Perl script to check for commonly used bash features not defined by POSIX"
HOMEPAGE="http://sourceforge.net/projects/checkbaskisms/"
SRC_URI="mirror://sourceforge/checkbaskisms/${PV}/${PN} -> ${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long"

S=${WORKDIR}

src_install() {
	newbin "${DISTDIR}"/${P} ${PN}
}
