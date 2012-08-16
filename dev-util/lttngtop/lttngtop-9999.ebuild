# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="Linux Trace Toolkit - a top-like performance analyze utility"
HOMEPAGE="http://lttng.org"
EGIT_REPO_URI="git://git.lttng.org/${PN}.git"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/userspace-rcu
	dev-libs/glib:2
	dev-util/babeltrace
	dev-libs/popt
	sys-libs/ncurses
	sys-apps/util-linux
"
RDEPEND="${DEPEND}"
