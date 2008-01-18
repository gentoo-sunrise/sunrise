# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

ESVN_REPO_URI="https://faracvs.cs.uni-magdeburg.de/svn/christsc/${PN}/${PN}/branches/${PV}"

DESCRIPTION="a wrapper script for creating backups using dar"
HOMEPAGE="https://faracvs.cs.uni-magdeburg.de/projects/christsc-darbackup/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-backup/dar-2.2.6
	|| ( dev-util/bdelta dev-util/xdelta )
	net-misc/openssh"

pkg_setup() {
	if ! built_with_use -o app-backup/dar dar32 dar64; then
		die 'You must have either dar32 or dar64 useflags for app-backup/dar enabled.'
	fi

	enewgroup backup
}

src_install() {
	dobin darbackup
	doman darbackup.1
}
