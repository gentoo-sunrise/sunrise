# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utilities for Gentoo repository and overlay development"
HOMEPAGE="http://gentooexperimental.org/~shillelagh"
SRC_URI="http://gentooexperimental.org/~shillelagh/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/python-2.3
	dev-util/subversion
	sys-apps/portage"

src_install() {
	dobin echangelog-tng sunrise-commit
	doman sunrise-commit.1
}
