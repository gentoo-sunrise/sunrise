# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Perl script to convert nmap scans to a Snort Host Attribute Table"
HOMEPAGE="http://code.google.com/p/hogger/"
SRC_URI="http://hogger.googlecode.com/files/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	perl-core/IO
	perl-core/Getopt-Long"

S=${WORKDIR}/${PN}

src_install () {
	newbin hogger.pl ${PN} || die
	dodoc README hogger.conf || die
}

pkg_postinst() {
	elog "An example configuration file can be found in /usr/share/doc/${PF}."
}
