# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

MY_PV=${PV/_p/ubuntu}
DESCRIPTION="Jewish Book Collection for use with Orayta (app-text/orayta)"
HOMEPAGE="http://orayta.googlecode.com/"
SRC_URI="http://launchpad.net/~moshe-wagner/+archive/orayta/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 LGPL-3 CC-BY-NC-SA-2.5 CC-BY-SA-3.0 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/bookstmp"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
