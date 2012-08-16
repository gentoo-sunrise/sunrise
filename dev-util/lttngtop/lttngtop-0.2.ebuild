# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Linux Trace Toolkit - a top-like performance analyze utility"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/userspace-rcu
	dev-libs/glib:2
	dev-util/babeltrace
	dev-libs/popt
	sys-libs/ncurses
	sys-apps/util-linux
"
RDEPEND="${DEPEND}"
