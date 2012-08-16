# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A command-line tool and library to read and convert trace files"
HOMEPAGE="http://lttng.org"
MY_P="${P/_/-}"
SRC_URI="http://lttng.org/files/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="test"

RDEPEND="dev-libs/glib:2
	dev-libs/popt
	sys-apps/util-linux
	"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf $(use_enable test glibtest)
}
