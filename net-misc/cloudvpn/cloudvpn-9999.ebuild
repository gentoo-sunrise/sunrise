# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="secure mesh networking VPN"
HOMEPAGE="http://e-x-a.org/"
EGIT_REPO_URI="http://e-x-a.org/repos/cloudvpn.git"
EGIT_BRANCH="master"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="net-libs/gnutls"
DEPEND="${RDEPEND}
	sys-devel/automake"

EGIT_BOOTSTRAP="autogen.sh"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README || die "dodoc README failed"
}
