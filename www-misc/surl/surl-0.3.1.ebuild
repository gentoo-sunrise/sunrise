# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="a command-line interface to http://metamark.net/"
HOMEPAGE="http://sourceforge.net/projects/surl"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
