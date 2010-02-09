# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_P=$(delete_version_separator "_" ${P})

DESCRIPTION="A collection of C++ classes which allow serial port access on POSIX systems like an iostream object"
HOMEPAGE="http://sourceforge.net/projects/libserial/"
SRC_URI="http://dev.gentooexperimental.org/~idl0r/distfiles/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

RDEPEND=""
DEPEND="dev-python/sip"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	doman doc/man/man3/*.3 || die "Install man pages failed!"

	if use doc; then
		dohtml -r doc/html/* || die "Install html pages failed!"
	fi

	if use examples; then
		docinto examples
		dodoc examples/{read,write}_port.cpp || die "dodoc failed";
	fi
}
