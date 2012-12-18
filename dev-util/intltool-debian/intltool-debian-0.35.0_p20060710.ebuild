# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

MY_PV=${PV/_p/+}.1

DESCRIPTION="Internationalization Tool Collection with support for RFC822 compliant config files"
HOMEPAGE="http://packages.qa.debian.org/intltool-debian"
SRC_URI="mirror://debian/pool/main/i/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8.1
	dev-perl/XML-Parser
	sys-devel/gettext
	virtual/perl-Getopt-Long"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	# These scripts are a used by debian packages and are not installed in /usr/bin since
	# they would collide with dev-util/intltool.
	exeinto /usr/share/${PN}
	doexe intltool-bin/*
	dodoc AUTHORS debian/{README.Debian,changelog}
}
