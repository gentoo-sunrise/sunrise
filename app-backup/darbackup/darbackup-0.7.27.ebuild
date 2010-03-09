# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils subversion

ESVN_REPO_URI="https://faracvs.cs.uni-magdeburg.de/svn/christsc-${PN}/${PN}/branches/${PV}"
ESVN_USER="anonymous"
ESVN_PASSWORD="anonymous"
ESVN_OPTIONS="--non-interactive"

DESCRIPTION="Wrapper script for app-backup/dar to make backups easier"
HOMEPAGE="https://faracvs.cs.uni-magdeburg.de/projects/christsc-darbackup/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-backup/dar
	|| ( dev-util/bdelta dev-util/xdelta )
	net-misc/openssh"

pkg_setup() {
	enewgroup backup
}

src_install() {
	dobin ${PN} || die "dobin failed"
	doman ${PN}.1 || die "doman failed"
}
