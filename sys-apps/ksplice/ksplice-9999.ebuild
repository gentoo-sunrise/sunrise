# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="http://www.ksplice.com/git/ksplice.git"

inherit git

DESCRIPTION="Rebootless Linux kernel security updates"
HOMEPAGE="http://www.ksplice.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog || die "dodoc failed"
}
