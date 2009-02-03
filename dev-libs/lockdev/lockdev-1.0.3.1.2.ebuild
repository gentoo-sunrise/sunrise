# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools versionator

MY_PV=$(get_version_component_range 1-3)
DEB_PV=$(replace_version_separator 3 '-')

SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/l/${PN}/${PN}_${DEB_PV}.diff.gz"

DESCRIPTION="A simple Debian locking library"
HOMEPAGE="http://packages.debian.org/source/sid/lockdev"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	epatch ${PN}_${DEB_PV}.diff
	epatch "${FILESDIR}/${PN}.addautotools.patch"
	cd "${S}"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog ChangeLog.old README.debug || die
}
