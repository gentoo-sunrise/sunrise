# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils distutils

DESCRIPTION="This module contains some basic code needed in all kaa modules. This is a requirement for all the other kaa modules."
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sqlite lirc"

RDEPEND="dev-libs/libxml2
	sqlite? ( >=dev-libs/glib-2.4.0 >=dev-python/pysqlite-2.2 )
	lirc? ( dev-python/pylirc )"

pkg_setup() {
	if !(built_with_use dev-libs/libxml2 python); then
		eerror "dev-libs/libxml2 must be built with the 'python' USE flag"
		die "Recompile dev-libs/libxml2 with enabled 'python' USE flag"
	fi
}

