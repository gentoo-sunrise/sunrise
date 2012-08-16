# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="Linux Trace Toolkit - UST library"
HOMEPAGE="http://lttng.org"
EGIT_REPO_URI="git://git.lttng.org/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND="dev-libs/userspace-rcu"
RDEPEND="${DEPEND}"

src_prepare() {
	if ! use examples; then
		sed -i -e '/SUBDIRS/s:examples::' doc/Makefile.am || die
	fi
	eautoreconf
}
