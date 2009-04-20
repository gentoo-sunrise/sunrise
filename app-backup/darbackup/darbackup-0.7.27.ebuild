# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils subversion

ESVN_REPO_URI="https://faracvs.cs.uni-magdeburg.de/svn/christsc/${PN}/${PN}/branches/${PV}"

DESCRIPTION="a wrapper script for creating backups using dar"
HOMEPAGE="https://faracvs.cs.uni-magdeburg.de/projects/christsc-darbackup/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dar64"

RDEPEND="!dar64? ( app-backup/dar[dar32] )
	dar64? ( app-backup/dar[dar64] )
	|| ( dev-util/bdelta dev-util/xdelta )
	net-misc/openssh"

pkg_setup() {
	enewgroup backup
}

src_install() {
	dobin darbackup || die "dobin failed"
	doman darbackup.1 || die "doman failed"
}
