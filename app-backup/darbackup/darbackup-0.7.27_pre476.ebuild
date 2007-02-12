# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

ESVN_REPO_URI="https://faracvs.cs.uni-magdeburg.de/svn/christsc/${PN}/${PN}/branches/${P}"

DESCRIPTION="a wrapper script for creating backups using dar"
HOMEPAGE="https://faracvs.cs.uni-magdeburg.de/projects/christsc-darbackup/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=app-backup/dar-2.2.6
        || ( dev-util/bdelta dev-util/xdelta )
        net-misc/openssh"

pkg_setup() {
  if ! built_with_use dar dar32 && ! built_with_use dar dar64; then
    die 'You must have dar32 or dar64 useflags for dar enabled.'
  fi
}

src_install() {
	dobin darbackup
	doman darbackup.1
}

pkg_postinst() {
	enewgroup backup
}

