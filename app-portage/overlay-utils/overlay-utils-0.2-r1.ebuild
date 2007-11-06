# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utilities for Gentoo repository and overlay development"
HOMEPAGE="http://gentooexperimental.org/~shillelagh/"
SRC_URI="http://gentooexperimental.org/~shillelagh/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-portage/gentoolkit-dev-0.2.6.6
	dev-util/subversion
	>=sys-apps/portage-2.1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's/sbin\(\/functions\.sh\)/etc\/init\.d\1/' sunrise-commit || die "sed failed"
	sed -i -e 's/\(echangelog\)-tng/\1/' sunrise-commit || die "sed failed"
}

src_install() {
	dobin sunrise-commit
	doman sunrise-commit.1
}
