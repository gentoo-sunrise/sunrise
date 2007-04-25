# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Software modem written in C that uses an IAX channel instead of a traditional phone line"
HOMEPAGE="http://iaxmodem.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/tiff"
RDEPEND="${DEPEND}
	net-misc/hylafax"

src_install() {
	doman iaxmodem.1
	dobin iaxmodem
	insinto /etc/iaxmodem
	doins iaxmodem-cfg.ttyIAX
	newinitd "${FILESDIR}/iaxmodem.init.d" iaxmodem
}
