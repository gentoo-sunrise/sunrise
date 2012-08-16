# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="A command-line tool and library to read and convert trace files"
HOMEPAGE="http://lttng.org"
EGIT_REPO_URI="git://git.efficios.com/${PN}.git"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="test"

RDEPEND="dev-libs/glib:2
	dev-libs/popt
	sys-apps/util-linux
	"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"
src_configure() {
	econf $(use_enable test glibtest)
}
