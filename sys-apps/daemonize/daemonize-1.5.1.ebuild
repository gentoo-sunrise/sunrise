# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Runs a command as a Unix daemon"
HOMEPAGE="http://www.clapper.org/software/daemonize/"
SRC_URI="http://www.clapper.org/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	dobin "${S}"/${PN}
	doman "${S}"/${PN}.1
}
