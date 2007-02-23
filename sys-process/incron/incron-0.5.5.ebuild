# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod

DESCRIPTION="INotify based cron daemon"
HOMEPAGE="http://incron.aiken.cz/"
SRC_URI="http://inotify.aiken.cz/download/incron/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	ebegin "Checking for INOTIFY support"
	linux_chkconfig_present INOTIFY
	eend $?

	if [[ $? -ne 0 ]]; then
		die "INOTIFY support not enabled"
	fi

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
