# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils
DESCRIPTION="libcitadel contains code which is shared across all the components which make up the Citadel system"
HOMEPAGE="http://citadel.org/"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

#only here until copies are on gentoos mirrors:
RESTRICT="primaryuri"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sys-libs/db
	>=dev-libs/libical-0.43
	mail-filter/libsieve
	dev-libs/expat
	net-misc/curl"

RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
