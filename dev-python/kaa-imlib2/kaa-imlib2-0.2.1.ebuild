# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils distutils

DESCRIPTION="A powerful media metadata parser. The module is the successor of Python Imaging Library."
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/kaa-base-0.1.3
	dev-libs/libxml2
	media-libs/imlib2"

pkg_setup() {
	if !(built_with_use dev-libs/libxml2 python); then
		eerror "dev-libs/libxml2 must be built with 'python' support."
		die "Recompile dev-libs/libxml2 after enabling the 'python' USE flag"
	fi
}

