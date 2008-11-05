# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utilities for Gentoo repository and overlay development"
HOMEPAGE="http://gentooexperimental.org/~shillelagh/"
SRC_URI="http://gentooexperimental.org/~shillelagh/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-util/subversion
	>=sys-apps/portage-2.1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:/sbin/functions.sh:/etc/init.d/functions.sh:' sunrise-commit || die "sed failed"
}

src_install() {
	dobin sunrise-commit echangelog-tng || die
	doman sunrise-commit.1
}
